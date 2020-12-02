from datetime import datetime
from dateutil.relativedelta import relativedelta
from app.main import bp
from flask import render_template, flash, session, redirect, request
from flask import url_for
from flask_user import login_required
from .forms import UserProfileForm, UserNameForm, MemberAccountForm
from app.member.forms import MemberBankForm
from app.member.models import Service, MemberBank, Bank, UserDetail, Loan
from flask_table import Table, Col, OptCol, DateCol, create_table
from flask_login import current_user
from app import db


@bp.route('/', methods=['GET', 'POST'])
@bp.route('/index', methods=['GET', 'POST'])
def index():
    text = ""
    with open('README.md', 'r') as f:
        text = f.read()
    return render_template('index.html', text=text)


@bp.route('/dashboard')
@login_required
def dashboard():
    form = MemberAccountForm()
    form.tav.data = 159231
    form.remit_date.data = datetime.strptime('3/20/2020', '%m/%d/%Y')
    form.remit_amount.data = 20009

    class DaysAgoCol(Col):
        def td_format(self, content):
            today = datetime.now()
            age = relativedelta(today, content)
            years = age.years
            months = age.months
            days = age.days
            hours = age.hours
            minutes = age.minutes
            if years:
                s = str(years) + (' years' if years > 1 else ' year')
            elif months:
                s = str(months) + (' months' if months > 1 else ' month')
            elif days:
                s = str(days) + (' days' if days > 1 else ' day')
            elif hours:
                s = str(hours) + (' hours' if hours > 1 else ' hour')
            elif minutes:
                s = str(minutes) + (' minutes' if minutes > 1 else ' minute')
            else:
                s = 'A few seconds '
            return content.strftime('%Y-%m-%d') + ' (' + s + ' ago)'

    LoanTable = create_table('LoanTable')\
        .add_column('date_filed',
                    DateCol('Date Filed', date_format='YYYY-MM-dd'))\
        .add_column('date_filed', DaysAgoCol('Date Filed'))\
        .add_column('amount', Col('Principal'))\
        .add_column('terms', Col('Terms'))
    LoanTable.classes = ['table', 'table-condensed', 'table-striped']

    loans = Loan.query.filter_by(user_id=current_user.id)\
        .order_by(Loan.date_filed.desc()).limit(5).all()
    table = LoanTable(loans)

    services = Service.query.order_by(Service.id).all()

    return render_template('main/dashboard.html', form=form, services=services,
                           loans=loans, table=table)


class BankAccountTable(Table):
    classes = ['table', 'table-condensed', 'table-striped', 'responsive']
    no_items = 'No account defined.'
    account_number = Col('Account Number')
    account_name = Col('Account Name')
    banks = Bank.query.all()
    bank_options = {b.id: b.short_name for b in banks}
    bank_id = OptCol('Bank', choices=bank_options)


@bp.route('/user-profile/<int:user_id>', methods=['GET', 'POST'])
@login_required
def user_profile(user_id):
    user_detail = UserDetail.query.filter_by(user_id=user_id).first()
    bank_accounts = MemberBank.query.filter_by(user_id=user_id).all()
    table = BankAccountTable(bank_accounts)
    form = UserProfileForm(obj=user_detail)
    form.position.data = 'Executive Assistant III'
    form.salary.data = 51000
    form.office.data = "OAAFA"
    form.beneficiaries.data = "Almira\nAda\nAdrian\nChanchan :)"
    return render_template(
        'user_profile.html',
        form=form,
        user_id=user_id,
        bank_accounts=bank_accounts,
        table=table)


@bp.route('/edit-user-name/<int:user_id>', methods=['GET', 'POST'])
@login_required
def edit_user_name(user_id):
    user_detail = UserDetail.query.filter_by(user_id=user_id).first()
    form = UserNameForm(obj=user_detail)
    if form.validate_on_submit():
        flash("TODO: You have updated your Name.")

        if 'back_url' in session:
            return redirect(session['back_url'])

    return render_template('edit_user_name.html', form=form)


@bp.route('/edit-member-banks/<int:user_id>', methods=['GET', 'POST'])
@login_required
def edit_member_banks(user_id):
    banks = Bank.all_active()
    bank_accounts = MemberBank.query.filter_by(user_id=user_id).all()
    table = BankAccountTable(bank_accounts)
    form = MemberBankForm()
    form.bank_name.choices = [(bank.id, bank.name) for bank in banks]

    if not request.form:
        form.account_name.data = current_user.detail.full_name

    if form.validate_on_submit():
        mb = MemberBank(bank_id=form.bank_name.data,
                        user_id=user_id,
                        account_number=form.account_number.data,
                        account_name=form.account_name.data)
        if mb.is_unique_record():
            db.session.add(mb)
            db.session.commit()
            flash('Bank account successfully added.', 'info')
            return redirect(url_for('main.edit_member_banks',
                                    user_id=user_id))
        else:
            flash('The account was not saved because a duplicate was found.',
                  'error')

    return render_template(
        'edit_member_banks.html', form=form, table=table,
        bank_accounts=bank_accounts)


@bp.route('/delete-member-bank/<int:user_id>/<int:membank_id>',
          methods=['GET', 'POST'])
@login_required
def delete_member_bank(user_id, membank_id):
    member_bank = MemberBank.query.get_or_404(membank_id)
    db.session.delete(member_bank)
    db.session.commit()
    flash('Bank Account successfully deleted.')
    return redirect(url_for('main.edit_member_banks', user_id=user_id))
