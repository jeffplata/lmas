from flask_wtf import FlaskForm
from wtforms import SubmitField, StringField, HiddenField, SelectField
from wtforms.validators import DataRequired, Email
from flask_wtf.file import FileField
from flask_admin.form.widgets import Select2Widget


class UploadForm(FlaskForm):
    filename = FileField(
        'Select Excel Source File',
        validators=[DataRequired()])
    submit = SubmitField('Import Selected File')


class MemberForm(FlaskForm):
    user_id = HiddenField()
    salary_data = HiddenField()
    email = StringField(validators=[DataRequired(), Email()])
    last_name = StringField(validators=[DataRequired()])
    first_name = StringField(validators=[DataRequired()])
    middle_name = StringField()
    suffix = StringField()
    SGSI = SelectField('Salary', coerce=int, widget=Select2Widget())
