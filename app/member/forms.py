from flask_wtf import FlaskForm
from wtforms import DecimalField, SelectField, SubmitField
from wtforms.validators import DataRequired


class ApplyForLoanForm(FlaskForm):
    """Form for Apply Loan."""

    amount = DecimalField(validators=[DataRequired()])
    terms = SelectField(coerce=int)
    continue_1 = SubmitField()
