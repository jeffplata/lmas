from app import db
from flask_user import UserMixin


# Define a base model for other database tables to inherit
class Base(db.Model):
    __abstract__ = True
    id = db.Column(db.Integer, primary_key=True)
    date_created = db.Column(db.DateTime, server_default=db.func.current_timestamp())
    date_modified = db.Column(db.DateTime, server_default=db.func.current_timestamp(),
                              server_onupdate=db.func.current_timestamp())


class User(Base, UserMixin):
    __tablename__ = 'auth_user'
    username = db.Column(db.String(128), nullable=True)
    email = db.Column(db.String(128), nullable=False, unique=True)

    password = db.Column(db.String(255))

    # the confirm date should be set automatically as user email confirmation
    #   will not be implemented
    email_confirmed_at = db.Column(db.DateTime,
                                   default=db.func.current_timestamp())
    # is_enabled = db.Column(db.Boolean(), nullable=False, default=False)
    active = db.Column(db.Boolean())

    employee_number = db.Column(db.String(20))
    db.UniqueConstraint(employee_number)

    detail = db.relationship('UserDetail', uselist=False, backref='auth_user')

    roles = db.relationship('Role', secondary='auth_user_roles',
                            backref=db.backref('users', lazy='dynamic'))

    # this is a workaround for for Flask-Admin 'Already exist.' error
    #   on fields with unique=True (see email field in User)
    def __eq__(self, other):
        return self.id == other.id if other else False

    def __repr__(self):
        # return '<User %r>' % (self.username)
        return f"<User {self.username or self.email}>"

    def __str__(self):
        return self.username or self.email

    # def set_password(self, password):
    #     self.password = generate_password_hash(password)

    # def check_password(self, password):
    #     return check_password_hash(self.password, password)

    # def get_reset_password_token(self, expires_in=600):
    #     return jwt.encode(
    #         {'reset_password': self.id, 'exp': time() + expires_in},
    #         current_app.config['SECRET_KEY'], algorithm='HS256').\
    #                   #decode('utf-8')

    # def get_roles(self):
    #     return role

    # @staticmethod
    # def verify_reset_password_token(token):
    #     try:
    #         id = jwt.decode(token, current_app.config['SECRET_KEY'],
    #                         algorithms=['HS256'])['reset_password']
    #     except:
    #         return
    #     return User.query.get(id)


class Role(Base):
    __tablename__ = 'auth_role'
    # id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    label = db.Column(db.Unicode(255), server_default=u'')

    def __repr__(self):
        return '<Role %r>' % (self.name)

    def __str__(self):
        return self.name or ""


class UserRoles(Base):
    __tablename__ = 'auth_user_roles'
    # id = db.Column(db.Integer(), primary_key=True)
    user_id = db.Column(db.Integer(),
                        db.ForeignKey(
                            'auth_user.id', ondelete='CASCADE'))
    role_id = db.Column(db.Integer(),
                        db.ForeignKey(
                            'auth_role.id', ondelete='CASCADE'))
