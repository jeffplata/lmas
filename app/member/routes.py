from app.member import bp
from flask import render_template
from flask_user import login_required
from app.user_models import User
from app.member.models import Service


# TODO: transfer this to the 'member' package blueprint
@bp.route('/apply-for-loan/<int:user_id>/<int:service_id>',
          methods=['GET', 'POST'])
@login_required
def apply_for_loan(user_id, service_id):
    user = User.query.get(user_id)
    service = Service.query.get(service_id)
    return render_template('member/apply_for_loan.html',
                           user=user,
                           service=service)


@bp.route('/contributions/<int:user_id>')
@login_required
def contributions(user_id):
    c = [
        [2010, 4360.01, 8720.02, 13080.03],
        [2011, 4862.12, 9724.24, 14586.36]
    ]
    return render_template('member/contributions.html', contributions=c)
