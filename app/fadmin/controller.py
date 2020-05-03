# from app.fadmin import bp
from flask_admin import Admin, AdminIndexView
from flask_admin.contrib.sqla import ModelView
from flask_user import current_user
from flask import current_app

from app import db
from app.user_models import User, Role, UserDetail
from app.member.models import Service


class MyAdminIndexView(AdminIndexView):
    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_roles('admin')

app_name = current_app.config['USER_APP_NAME']

admin = Admin(name=app_name + ' Admin', template_mode='bootstrap3',
              index_view=MyAdminIndexView(template='fadmin/index.html'))


class MyModelView(ModelView):
    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_role('admin')


admin.add_view(MyModelView(User, db.session))
admin.add_view(MyModelView(Role, db.session))

# app-specific views
admin.add_view(MyModelView(UserDetail, db.session))
admin.add_view(MyModelView(Service, db.session))
