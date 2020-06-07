from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, TextAreaField,\
    DecimalField, DateField
from wtforms.validators import DataRequired
# from app import db
# from app.models import Office, Payroll_Type


class UserProfileForm(FlaskForm):
    """Form to display user profile."""

    full_name = StringField(render_kw={"readonly": True})
    position = StringField(render_kw={"readonly": True})
    salary = StringField(render_kw={"readonly": True})
    office = StringField(render_kw={"readonly": True})
    beneficiaries = TextAreaField(
        render_kw={"readonly": True, 'style': 'resize:none'})


class UserNameForm(FlaskForm):
    """Form to edit user details."""

    # let StringField do its job
    first_name = StringField(validators=[DataRequired()])
    last_name = StringField(validators=[DataRequired()])
    middle_name = StringField()
    suffix = StringField()
    full_name = StringField(render_kw={"readonly": True})
    submit = SubmitField('Submit')


class MemberAccountForm(FlaskForm):
    """Form to display member account details, like TAV, etc."""

    tav = DecimalField("TAV")
    remit_date = DateField("Last Remittance")
    remit_amount = DecimalField("")


# class SectionForm(FlaskForm):
#     """
#     Form for admin to add or edit a section
#     """
#     name = StringField('Name', validators=[DataRequired()])
#     submit = SubmitField('Submit')


# class PayrollForm(FlaskForm):
#     """
#     Form to add or edit a payroll
#     """
#     # office_id = SelectField('Office', coerce=int, choices=Office_List())
#     office_id = SelectField('Office', coerce=int)
#     date = DateField('Date', validators=[DataRequired()])
#     # payroll_type_id = SelectField('Type', coerce=int, choices=Payroll_Type_List())
#     payroll_type_id = SelectField('Type', coerce=int)
#     period = StringField('Period', validators=[DataRequired()])
#     submit = SubmitField('Submit')


# class PayrollGroupForm(FlaskForm):
#     """
#     Form for users to add or edit a payroll group
#     """
#     name = StringField('Name', validators=[DataRequired()])
#     submit = SubmitField('Submit')
