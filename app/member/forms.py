from flask_wtf import FlaskForm
from wtforms import SelectField, SubmitField,\
    StringField, BooleanField, HiddenField
from wtforms.validators import DataRequired
from flask_admin.form.widgets import Select2Widget


class ApplyForLoanForm(FlaskForm):
    """Form for Apply Loan."""

    # amount = DecimalField(validators=[DataRequired()])
    amount = SelectField(validators=[DataRequired()],
                         choices=[], coerce=float, widget=Select2Widget())
    terms = SelectField(validators=[DataRequired()], choices=[], coerce=int,
                        widget=Select2Widget())
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
    submit = SubmitField('+Add account')
