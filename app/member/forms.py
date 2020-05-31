from flask_wtf import FlaskForm
from wtforms import DecimalField, SelectField, SubmitField,\
    StringField, BooleanField, HiddenField
from wtforms.validators import DataRequired


class ApplyForLoanForm(FlaskForm):
    """Form for Apply Loan."""

    amount = DecimalField(validators=[DataRequired()])
    terms = SelectField(validators=[DataRequired()], choices=[], coerce=int)
    # continue_1 = SubmitField('Continue', render_kw={"class_": "btn-primary"})


class BankDetailsForm(FlaskForm):
    """Form for Bank Details when applying for loan."""

    bank_name = SelectField(validators=[DataRequired()], choices=[],
                            coerce=int)
    account_number = StringField(validators=[DataRequired()])
    account_name = StringField(validators=[DataRequired()])
    save_account = BooleanField(default=True)
    # submit = SubmitField()


class MemberBankForm(FlaskForm):
    """Form for Member Bank when applying for loan."""

    member_bank_id = HiddenField()
    bank_name = SelectField(validators=[DataRequired()], choices=[],
                            coerce=int)
    account_number = StringField(validators=[DataRequired()])
    account_name = StringField(validators=[DataRequired()])
    save_account = BooleanField(default=True)
