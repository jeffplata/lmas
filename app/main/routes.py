from app.main import bp
from flask import render_template, flash, session, redirect
from flask_user import login_required
from .forms import UserProfileForm
from app.user_models import UserDetail


@bp.route('/', methods=['GET', 'POST'])
@bp.route('/index', methods=['GET', 'POST'])
def index():
    text = ""
    with open('README.md', 'r') as f:
        text = f.read()
    return render_template('index.html', text=text)


@bp.route('/user-profile/<int:user_id>')
@login_required
def user_profile(user_id):
    user_detail = UserDetail.query.filter_by(user_id=user_id).first()
    return render_template('user_profile.html', user_detail=user_detail)


@bp.route('/edit-user-name/<int:user_id>', methods=['GET', 'POST'])
@login_required
def edit_user_name(user_id):
    user_detail = UserDetail.query.filter_by(user_id=user_id).first()
    form = UserProfileForm(obj=user_detail)
    if form.validate_on_submit():
        flash("TODO: You have updated your Name.")

        if 'back_url' in session:
            return redirect(session['back_url'])

    return render_template('edit_user_name.html', form=form)
