# from app.fadmin import bp
from flask_admin import Admin, AdminIndexView
from flask_admin.contrib.sqla import ModelView
from flask_admin.menu import MenuLink
# from flask_admin.form import SecureForm
from flask_user import current_user
from flask import current_app, url_for

from app import db
from app.user_models import User, Role, UserDetail
from app.member.models import Service
from wtforms.fields.simple import TextAreaField


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


class ServiceModelView(MyModelView):

    form_overrides = {'description': TextAreaField}


admin.add_view(MyModelView(UserDetail, db.session, category='User'))
admin.add_view(ServiceModelView(Service, db.session))