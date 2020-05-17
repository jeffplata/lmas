from app.member import bp
from flask import render_template
from flask_user import login_required
from app.user_models import User
from app.member.models import Service, AmortizationSchedule
from .forms import ApplyForLoanForm
from datetime import datetime
from decimal import Decimal


amount = 51000
terms = 12

@bp.route('/apply-for-loan/<int:user_id>/<int:service_id>',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan(user_id, service_id):
    # TODO: continue here
    user = User.query.get(user_id)
    if not user.detail:
        return render_template('member/member_not_defined.html')
    service = Service.query.get(service_id)
    # loan_amount = 51000
    form = ApplyForLoanForm()
    # form.amount.data = 51000
    # form.terms.data = 12
    global amount
    global terms
    form.amount.data = amount
    form.terms.data = terms
    form.terms.choices = [(x, str(x)) for x in 
        range(service.min_term,service.max_term+1)]

    if form.validate_on_submit():
        print("==========")
        print(form.amount.data)
        amount = form.amount.data
        terms = form.terms.data

    form.amount.data = amount
    form.terms.data = terms
    balance = 5500
    process_fee = 250
    net_proceeds = form.amount.data - balance - process_fee

    amortization = []
    prev_bal = form.amount.data
    due_date = datetime.now() 
    for i in range(1, service.max_term+1):
        principal_am = round(min(Decimal(form.amount.data/service.max_term), prev_bal),2)
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

    return render_template('member/apply_for_loan.html',
                           user=user,
                           service=service,
                           form=form,
                           balance=balance,
                           process_fee=process_fee,
                           net_proceeds=net_proceeds,
                           amortization=amortization)


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
