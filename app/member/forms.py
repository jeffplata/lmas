from flask_wtf import FlaskForm
from wtforms import DecimalField, SelectField, SubmitField
from wtforms.validators import DataRequired


class ApplyForLoanForm(FlaskForm):
    """Form for Apply Loan."""

    amount = DecimalField(validators=[DataRequired()])
    terms = SelectField(validators=[DataRequired()], coerce=int)
    continue_1 = SubmitField('Continue', render_kw={"class_": "btn-primary"})
