from datetime import datetime
from app.main import bp
from flask import render_template, flash, session, redirect
from flask_user import login_required
from .forms import UserProfileForm, UserNameForm, MemberAccountForm
from app.user_models import UserDetail
from app.member.models import Service


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

    services = []
    d = 'Maximum loanable amount: 80% of TAV\n' \
        '12-, 24-, and 36-month term\n' \
        'Renewable after 25% payment.'
    s = Service(id=1, name='Regular', description=d)
    services.append(s)
    d = 'Maximum loanable amount: 80% of Basic Pay\n' \
        '1-time payment\n' \
        'Payment due on May 15, 2020.'
    s = Service(id=2, name='Special', description=d)
    services.append(s)

    return render_template('main/dashboard.html', form=form, services=services)


@bp.route('/user-profile/<int:user_id>', methods=['GET', 'POST'])
@login_required
def user_profile(user_id):
    user_detail = UserDetail.query.filter_by(user_id=user_id).first()
    form = UserProfileForm(obj=user_detail)
    form.position.data = 'Executive Assistant III'
    form.salary.data = 51000
    form.office.data = "OAAFA"
    form.beneficiaries.data = "Almira\nAda\nAdrian\nChanchan :)"
    return render_template('user_profile.html', form=form, user_id=user_id)


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
