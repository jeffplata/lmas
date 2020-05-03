# from app.fadmin import bp
from flask_admin import Admin, AdminIndexView
from flask_admin.contrib.sqla import ModelView
from flask_admin.menu import MenuLink
from flask_user import current_user
from flask import current_app, url_for

from app import db
# import app
from app.user_models import User, Role, UserDetail
from app.member.models import Service


class MyAdminIndexView(AdminIndexView):
    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_roles('admin')

app_name = current_app.config['USER_APP_NAME']

admin = Admin(name=app_name + ' Admin', template_mode='bootstrap3',
              index_view=MyAdminIndexView(template='fadmin/index.html'))

# admin.add_link(MenuLink(name='Public Website', category='', url='/'))


# @bp.before_app_first_request
@current_app.before_first_request
def assign_links_to_admin():
    admin.add_link(MenuLink(name='Public Website', category='',
                            url=url_for('main.index')))
    admin.add_link(MenuLink(name='Logout', category='',
                            url=url_for('user.logout')))


class MyModelView(ModelView):
    def is_accessible(self):
        return (not current_user.is_anonymous) and \
            current_user.has_roles('admin')


admin.add_view(MyModelView(User, db.session, category='User'))
admin.add_view(MyModelView(Role, db.session, category='User'))

# app-specific views
admin.add_view(MyModelView(UserDetail, db.session, category='User'))
admin.add_view(MyModelView(Service, db.session))
