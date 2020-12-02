from app.member import bp

from flask import flash, redirect, render_template, request,\
    url_for, abort
from flask_user import login_required
from app.user_models import User
from app.member.models import Service, AmortizationSchedule, Loan, Bank,\
    MemberBank, UserDetail
from .forms import ApplyForLoanForm, MemberBankForm
from datetime import datetime
from dateutil.relativedelta import relativedelta
from decimal import Decimal
from app import db


user = None
service = None
loan = None
amortization = []


def amortize_loan(amount, terms, interest_rate, date_filed):
    amortization = []
    prev_bal = amount
    due_date_1 = date_filed + relativedelta(months=1)
    due_date = due_date_1

    for i in range(1, terms + 1):
        if i == (terms):
            principal_am = prev_bal
        else:
            principal_am = round(Decimal(amount / terms), 2)
        interest_am = round(prev_bal * interest_rate * Decimal('0.01'),
                            2)
        am = AmortizationSchedule(
            due_date=due_date,
            previous_balance=prev_bal,
            principal=principal_am,
            interest=interest_am,
            ideal_balance=prev_bal - principal_am)
        amortization.append(am)
        prev_bal = am.ideal_balance
        due_date = due_date_1 + relativedelta(months=i)

    return amortization


@bp.route('/apply-for-loan/<int:user_id>/<int:service_id>',
          methods=['GET', 'POST'])
@bp.route('/apply-for-loan/<int:user_id>/<int:service_id>/<reload>',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan(user_id, service_id, reload='0'):
    global user
    global service
    global loan
    global amortization

    # Load the user and service if coming from the Dashboard or Services
    #   or from the Checkout to ensure eligibility
    user = User.query.get(user_id)
    if not user.detail:
        return render_template('member/member_not_defined.html')
    member = UserDetail.query.filter_by(user_id=user_id).first()
    service = Service.query.get(service_id)

    balance = 5500
    process_fee = 250
    # default_loan_amount = 51000  # user.details.basic_salary * 0.8
    default_loan_amount = member.salary.salary
    default_loan_terms = service.max_term

    form = ApplyForLoanForm()
    form.terms.choices = [(x, str(x)) for x in
                          range(service.min_term, service.max_term + 1)]
    n = round(member.salary.salary, -3)
    form.amount.choices =\
        [(member.salary.salary, str(round(member.salary.salary, 0)))] +\
        [(x, str(x)) for x in range(int(n), 1000, -1000)]

    if request.form:
        form.amount.data = Decimal(request.form['amount'])
        form.terms.data = int(request.form['terms'])
    else:
        if (reload == '1') and loan:
            form.amount.data = loan.amount
            form.terms.data = loan.terms
        else:
            form.amount.data = default_loan_amount
            form.terms.data = default_loan_terms

    loan_amount = form.amount.data
    loan_terms = form.terms.data

    net_proceeds = loan_amount - balance - process_fee

    date_filed = datetime.now()

    amortization = amortize_loan(loan_amount,
                                 loan_terms,
                                 service.interest_rate,
                                 date_filed)
    loan = Loan(
        user_id=user.id,
        service_id=service.id,
        date_filed=date_filed,
        amount=loan_amount,
        terms=loan_terms,
        interest_rate=service.interest_rate,
        previous_balance=balance,
        processing_fee=process_fee,
        net_proceeds=net_proceeds,
        first_due_date=amortization[0].due_date,
        last_due_date=amortization[-1].due_date,
        status='submitted')

    if form.validate_on_submit():
        if 'continue' in request.form:
            # session['back_url'] = request.url

            return redirect(url_for('member.apply_for_loan_checkout'))

    return render_template('member/apply_for_loan.html',
                           user=user,
                           service=service,
                           loan=loan,
                           form=form,
                           amortization=amortization)


@bp.route('/apply-for-loan-checkout/',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan_checkout():
    global user
    global service
    global loan
    global amortization

    if not loan:
        flash("""You have been redirected because the page you are trying
            to access is no longer valid.""", 'info')
        return redirect(url_for('main.dashboard'))

    banks = Bank.all_active()

    form = MemberBankForm()
    form.bank_name.choices = [(bank.id, bank.name) for bank in banks]

    if not request.form:
        member_banks = MemberBank.query.filter_by(user_id=user.id).all()
        if member_banks:
            form.member_bank_id.data = member_banks[0].id
            form.account_number.data = member_banks[0].account_number
            form.account_name.data = member_banks[0].account_name
            form.bank_name.data = member_banks[0].bank.name
        else:
            form.account_number.data = ''
            form.account_name.data = user.detail.full_name

    if request.method == 'POST':

        if 'back' in request.form:
            return redirect(url_for('member.apply_for_loan',
                                    user_id=user.id,
                                    service_id=service.id,
                                    reload='1'))

        if form.validate_on_submit():

            mb_id = form.member_bank_id.data
            mb = MemberBank(
                id=mb_id,
                user_id=user.id,
                bank_id=form.bank_name.data,
                account_number=form.account_number.data,
                account_name=form.account_name.data)

            if mb.is_unique_record():
                mb.id = None
                db.session.add(mb)
            db.session.flush()
            loan.memberbank_id = mb.id
            db.session.add(loan)
            # TODO: continue here: account edit when only account name changed
            try:
                db.session.commit()
                user = None
                service = None
                loan = None
                amortization = []
                return render_template('member/apply_for_loan_success.html')
            except Exception:
                raise
                flash('Error occurred.', 'error')
                db.session.rollback()

    return render_template('member/apply_for_loan_checkout.html',
                           user=user,
                           service=service,
                           loan=loan,
                           amortization=amortization,
                           member_banks=member_banks,
                           form=form)


@bp.route('/loans/<int:user_id>')
@login_required
def loans(user_id):
    loans = Loan.query.filter_by(user_id=user_id)\
        .order_by(Loan.date_filed.desc()).all()

    return render_template('member/loans.html', loans=loans)


@bp.route('/loan/<int:loan_id>')
@login_required
def loan(loan_id):
    loan = Loan.query.filter_by(id=loan_id).first()
    if not loan:
        abort(404)

    return render_template('member/loan.html', loan=loan)


@bp.route('/contributions/<int:user_id>')
@login_required
def contributions(user_id):
    c = [
        [2010, 4360.01, 8720.02, 13080.03],
        [2011, 4862.12, 9724.24, 14586.36],
        ['', '', '<b>Total</b>', 27666.39]
    ]
    return render_template('member/contributions.html', contributions=c)


@bp.route('/contributions/<int:user_id>/<int:year>')
@login_required
def contributions_by_year(user_id, year):
    c = [
        ['1/20/2010', 'Isabela PO', 'Contribution', 421.56, '1/1/2010'],
        ['1/20/2010', 'Isabela PO', 'Government Share', 843.12, '1/1/2010'],
        ['2/20/2010', 'Isabela PO', 'Contribution', 421.56, '2/1/2010'],
        ['2/20/2010', 'Isabela PO', 'Government Share', 843.12, '2/1/2010'],
    ]
    return render_template(
        'member/contributions_by_year.html', contributions=c, year=year)


@bp.route('/services')
@login_required
def services():
    services = Service.query.order_by(Service.id).all()
    return render_template(
        'member/services.html', services=services)
