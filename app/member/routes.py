from app.member import bp
from flask import render_template, request, redirect, url_for
from flask_user import login_required
from app.user_models import User
from app.member.models import Service, AmortizationSchedule, Loan
from .forms import ApplyForLoanForm, BankDetailsForm
from datetime import datetime
from dateutil.relativedelta import relativedelta
from decimal import Decimal


@bp.route('/apply-for-loan/<int:user_id>/<int:service_id>',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan(user_id, service_id):
    user = User.query.get(user_id)
    if not user.detail:
        return render_template('member/member_not_defined.html')
    service = Service.query.get(service_id)

    form = ApplyForLoanForm()
    form.terms.choices = [(x, str(x)) for x in 
        range(service.min_term,service.max_term+1)]

    if not form.amount.data:
        form.amount.data = 51000 # user.details.basic_salary * 0.8
    if not form.terms.data:
        form.terms.data = service.max_term

    balance = 5500
    process_fee = 250
    net_proceeds = form.amount.data - balance - process_fee

    if form.validate_on_submit():
        if 'continue' in request.form:
            # return render_template('member/apply_for_loan_checkout.html')
            # return apply_for_loan_checkout(user, service)
            loan = Loan(amount=form.amount.data,
                        terms=form.terms.data,
                        previous_balance=balance,
                        processing_fee=process_fee,
                        net_proceeds=net_proceeds
                        )
            return redirect(url_for('member.apply_for_loan_checkout',
                                    user=user,
                                    service=service,
                                    loan=loan))
            # TODO: //return render_template here
            # return apply_for_loan_checkout(user, service, loan)


    amortization = []
    prev_bal = form.amount.data
    due_date_1 = datetime.now() + relativedelta(months=1)
    due_date = due_date_1
    for i in range(1, form.terms.data+1):
        if i == (form.terms.data):
            principal_am = prev_bal
        else:
            principal_am = round(Decimal(form.amount.data/form.terms.data), 2)
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

    return render_template('member/apply_for_loan.html',
                           user=user,
                           service=service,
                           form=form,
                           balance=balance,
                           process_fee=process_fee,
                           net_proceeds=net_proceeds,
                           amortization=amortization)


@bp.route('/apply-for-loan-checkout/<user>/<service>/<loan>',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan_checkout(user, service, loan):
    print("[[[[[[[[[[[[[[[")
    view_args = request.view_args
    print(user.id)
    form = BankDetailsForm()
    form.bank_name.choices.append((1,'Land Bank of the Philippines'))
    form.bank_name.choices.append((2,'Philippine National Bank'))

    if form.validate_on_submit():
        return render_template('member/apply_for_loan_success.html')

    return render_template('member/apply_for_loan_checkout.html',
                           user=user,
                           service=service,
                           loan=loan,
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
