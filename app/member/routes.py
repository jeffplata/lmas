from app.member import bp
from flask import render_template, request, redirect, url_for,\
    session, flash
from flask_user import login_required
from app.user_models import User
from app.member.models import Service, AmortizationSchedule, Loan
from .forms import ApplyForLoanForm, BankDetailsForm
from datetime import datetime
from dateutil.relativedelta import relativedelta
from decimal import Decimal


user = None
service = None
loan = None
amortization = []


def AmortizeLoan(loan):
    amortization = []
    prev_bal = loan.amount
    due_date_1 = datetime.now() + relativedelta(months=1)
    due_date = due_date_1

    for i in range(1, loan.terms+1):
        if i == (loan.terms):
            principal_am = prev_bal
        else:
            principal_am = round(Decimal(loan.amount/loan.terms), 2)
        interest_am = round(prev_bal*service.interest_rate*Decimal('0.01'),2)
        am = AmortizationSchedule(
            due_date=due_date,
            previous_balance=prev_bal,
            principal=principal_am,
            interest=interest_am,
            ideal_balance=prev_bal-principal_am
            )
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
    global new_record

    # if (not request.form):
    # Load the user and service if coming from the Dashboard or Services
    #   or from the Checkout to ensure eligibility
    user = User.query.get(user_id)
    if not user.detail:
        return render_template('member/member_not_defined.html')
    service = Service.query.get(service_id)

    balance = 5500
    process_fee = 250
    default_loan_amount = 51000 # user.details.basic_salary * 0.8
    default_loan_terms = service.max_term

    form = ApplyForLoanForm()
    form.terms.choices = [(x, str(x)) for x in 
        range(service.min_term,service.max_term+1)]

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

    loan = Loan(amount=loan_amount,
                terms=loan_terms,
                previous_balance=balance,
                processing_fee=process_fee,
                net_proceeds=net_proceeds
                )
    amortization = AmortizeLoan(loan)

    if form.validate_on_submit():
        if 'continue' in request.form:
            session['back_url'] = request.url

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

    form = BankDetailsForm(account_number='',account_name=user.detail.full_name)
    form.bank_name.choices.append((1,'Land Bank of the Philippines'))
    form.bank_name.choices.append((2,'Philippine National Bank'))

    if request.method == 'POST':

        if 'back' in request.form:
            return redirect(url_for('member.apply_for_loan', 
                user_id=user.id,
                service_id=service.id,
                reload='1'))

        if form.validate_on_submit():
            user = None
            service = None
            loan = None
            amortization = []
            return render_template('member/apply_for_loan_success.html')

    return render_template('member/apply_for_loan_checkout.html',
                           user=user,
                           service=service,
                           loan=loan,
                           amortization=amortization,
                           form=form)


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
