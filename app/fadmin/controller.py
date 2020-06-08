# from app.fadmin import bp
from flask_admin import Admin, AdminIndexView, BaseView, expose
from flask_admin.contrib.sqla import ModelView
from flask_admin.contrib.sqla.filters import BaseSQLAFilter
from flask_admin.menu import MenuLink
from flask_admin.actions import action
from flask_user import current_user
from flask import current_app, url_for, flash, redirect, request

from app import db
from app.user_models import User, Role, UserDetail
from app.member.models import Service, Bank, MemberBank, Loan,\
    SalaryGrade
from wtforms.fields.simple import TextAreaField
from .forms import UploadForm, MemberForm
from werkzeug.utils import secure_filename
from sqlalchemy import exc
from gettext import gettext, ngettext
from datetime import datetime


class MyAdminIndexView(AdminIndexView):
    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_roles('admin')


app_name = current_app.config['USER_APP_NAME']

admin = Admin(name=app_name + ' Admin', template_mode='bootstrap3',
              index_view=MyAdminIndexView(template='fadmin/index.html'))


@current_app.before_first_request
def assign_links_to_admin():
    admin.add_link(MenuLink(name='Public Website', category='',
                            url=url_for('main.index')))
    admin.add_link(MenuLink(name='Logout', category='',
                            url=url_for('user.logout')))


class MyModelView(ModelView):
    column_display_pk = True

    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_roles('admin')


class MyUserModelView(MyModelView):

    # if no password is supplied, provide one
    def on_model_change(self, form, model, is_created):
        if not model.password:
            model.password = current_app.user_manager.hash_password(
                current_app.config['DEFAULT_USR_PWD'])

    form_excluded_columns = ['date_created', 'date_modified', 'password',
                             'email_confirmed_at']


admin.add_view(MyUserModelView(User, db.session, category='User'))
admin.add_view(MyModelView(Role, db.session, category='User'))

# app-specific views


class AppLibModelView(MyModelView):
    form_excluded_columns = ['date_created', 'date_modified']
    can_export = True


class ServiceModelView(AppLibModelView):
    form_overrides = {'description': TextAreaField}


class FilterByBank(BaseSQLAFilter):
    def apply(self, query, value, alias=None):
        return query.filter_by(bank_id=value)

    def operation(self):
        return 'equals'

    def get_options(self, view):
        banks = Bank.query.all()
        return [(b.id, b.short_name) for b in banks]


class MemberBankView(AppLibModelView):
    column_filters = [
        User.email,
        FilterByBank(column='bank_id', name='Bank')]


class LoanView(AppLibModelView):
    column_list = ('id', 'date_filed', 'user.detail.full_name', 'amount',
                   'terms', 'previous_balance', 'processing_fee',
                   'net_proceeds', 'first_due_date', 'last_due_date')
    column_labels = {'user.detail.full_name': 'Borrower'}


class MemberView(AppLibModelView):
    form = MemberForm
    create_template = 'fadmin/create_member.html'
    column_list = ('id', 'user.email', 'full_name', 'salary.amount')
    column_labels = {'user.email': 'Email', 'salary.amount': 'Salary'}
    column_sortable_list = column_list

    # TODO: override validate_form() to check unique email address
    #     if ok, save/flush on on_model_chage to get the id
    #     and assign it to UserDetail.user_id
    def validate_form(self, form):
        if not form.user_id.data:
            # this is a new record
            user = User.query.filter_by(email=form.email.data).first()
            if user:
                if UserDetail.query.filter_by(user_id=user.id).first():
                    flash(f"Record not saved. '{form.email.data}' "
                          f"is used by another Member.")
                    return False
            return super(MyModelView, self).validate_form(form)

    def on_model_change(self, form, model, is_created=False):
        if is_created:
            user = User.query.filter_by(email=form.email.data).first()
            if user:
                if UserDetail.query.filter_by(user_id=user.id).first():
                    flash(f"Record not saved. '{form.email.data}' "
                          f"is used by another Member.")

                    return
            else:
                u = User(email=form.email.data,
                         email_confirmed_at=datetime.utcnow(),
                         password=current_app.user_manager.
                         hash_password('Password1'),
                         active=True)
                db.session.add(u)

            try:
                db.session.flush()  # flush, so we can access a user.id if new
                model.user_id = user.id
                db.session.commit()
            except Exception as e:
                db.session.rollback()  # do this immediately for SQLAlchemy
                if not self.handle_view_exception(e):
                    raise
            # except exc.SQLAlchemyError as e:
            #     db.session.rollback()  # do this immediately for SQLAlchemy
            #     messages = e.message if hasattr(e, 'message') else str(e)


class FilterSGByGrade(BaseSQLAFilter):
    def apply(self, query, value, alias=None):
        return query.filter_by(sg=value)

    def operation(self):
        return 'equals'

    def get_options(self, view):
        options = SalaryGrade.query.distinct(SalaryGrade.sg).\
            order_by(SalaryGrade.sg)
        return [(i.sg, i.sg) for i in options]


class FilterSGByStep(BaseSQLAFilter):
    def apply(self, query, value, alias=None):
        return query.filter_by(step=value)

    def operation(self):
        return 'equals'

    def get_options(self, view):
        options = SalaryGrade.query.distinct(SalaryGrade.step).\
            order_by(SalaryGrade.step)
        return [(i.step, i.step) for i in options]


class FilterSGByGroupName(BaseSQLAFilter):
    def apply(self, query, value, alias=None):
        return query.filter_by(group_name=value)

    def operation(self):
        return 'equals'

    def get_options(self, view):
        options = SalaryGrade.query.distinct(SalaryGrade.group_name)
        return [(i.group_name, i.group_name) for i in options]


class SalaryGradeView(AppLibModelView):
    column_default_sort = ('id')
    column_filters = [FilterSGByGrade(column='sg', name='Salary Grade'),
                      FilterSGByStep(column='step', name='Step'),
                      FilterSGByGroupName(column='group_name', name='Group'),
                      'active']

    @action('set_active', 'Set Active',
            "Do you want to set the selected records 'Active'?")
    def action_set_active(self, ids):
        do_change_active(self, ids)
        return

    @action('set_inactive', 'Set Inactive',
            "Do you want to set the selected records 'Inactive'?")
    def action_set_inactive(self, ids):
        do_change_active(self, ids, False)
        return


def do_change_active(self, ids, active=True):
    if active:
        setting = 'Active'
    else:
        setting = 'Inactive'

    try:
        records = SalaryGrade.query.filter(SalaryGrade.id.in_(ids)).all()
        count = 0
        for sgr in records:
            sgr.active = active
            count += 1

        db.session.commit()

        flash(ngettext(
            "Record was successfuly set '{}'.".format(setting),
            "{} records were successfully set '{}'.".format(count, setting),
            count))

    except Exception as e:
        if not self.handle_view_exception(e):
            raise

        flash(gettext(
            'Failed to change records status. %(error)s',
            error=str(e)), 'error')


class ImportDataView(BaseView):
    @expose('/', methods=['GET', 'POST'])
    def index(self):
        form = UploadForm()
        messages = ''
        if form.validate_on_submit():
            filename = secure_filename(form.filename.data.filename)
            try:
                request.save_book_to_database(
                    field_name='filename', session=db.session,
                    tables=[SalaryGrade])
                flash("You have successfully imported '{}' to {}".format(
                    filename, 'Salary Grade'))
                return redirect(url_for('admin.index'))
            except exc.SQLAlchemyError as e:
                db.session.rollback()  # do this immediately for SQLAlchemy
                messages = e.message if hasattr(e, 'message') else str(e)
                if (messages.find('not-null constraint') != -1):
                    messages = """Some or all required columns were not found
                    from the source file.<br>
                    <b>Ensure that the following columns are present:<br>
                    sg, step, salary, group_name</b>"""
            except Exception as e:
                db.session.rollback()
                messages = e.message if hasattr(e, 'message') else str(e)
                if (messages.find('Sheet') != -1):
                    messages = """Failed to import from '{}'.<br>
                    <b>Ensure that the sheet name is set to 'salary_grade'.</b>"""\
                    .format(filename)
                # else: catchall function

        return self.render(
            'fadmin/import_data.html',
            form=form,
            messages=messages)


admin.add_view(MemberView(UserDetail, db.session, category='User',
                          name='Members'))
admin.add_view(SalaryGradeView(SalaryGrade, db. session, category='User'))
admin.add_view(ServiceModelView(Service, db.session, category='Library'))
admin.add_view(AppLibModelView(Bank, db.session, category='Library'))
admin.add_view(MemberBankView(MemberBank, db.session, category='Library'))
admin.add_view(LoanView(Loan, db.session, category='Loan'))
admin.add_view(
    ImportDataView(
        name='Import Salary Grade', endpoint='import-data', category='Import'))
