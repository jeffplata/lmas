from flask_wtf import FlaskForm
from wtforms import SubmitField, StringField
from wtforms.validators import DataRequired, Email
from flask_wtf.file import FileField


class UploadForm(FlaskForm):
    filename = FileField(
        'Select Excel Source File',
        validators=[DataRequired()])
    submit = SubmitField('Import Selected File')


class MemberForm(FlaskForm):
    email = StringField(validators=[DataRequired(), Email()])
    last_name = StringField(validators=[DataRequired()])
    first_name = StringField(validators=[DataRequired()])
    middle_name = StringField()
    suffix = StringField()
