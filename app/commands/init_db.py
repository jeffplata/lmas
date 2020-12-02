import datetime
from flask import current_app
from flask_script import Command
from app import db
from app.user_models import User, Role

# app-specific
from app.member.models import LoanStatus

# to use: python manage init_db


class InitDbCommand(Command):
    """Initialize the database."""

    def run(self):
        init_db()


def init_db():
    """Initialize the database."""

    # db creation is done with alembic
    #   flask db migrate; flask db upgrade

    # db.drop_all()
    # db.create_all()
    create_users()


def create_users():
    """Create users."""
    # Create all tables
    # db.create_all()

    # Adding roles
    admin_role = find_or_create_role('admin', 'Admin')
    find_or_create_role('member', 'Member')
    checker_role = find_or_create_role('checker', 'Checker')
    endorser_role = find_or_create_role('endorser', 'Endorser')
    committee_role = find_or_create_role('committee', 'Committee')
    ceo_role = find_or_create_role('ceo', 'CEO')
    manager_role = find_or_create_role('manager', 'Manager')
    processor_role = find_or_create_role('processor', 'Processor')
    payroll_role = find_or_create_role('payroll', 'Payroll')

    # Add users
    find_or_create_user('admin', 'admin@example.com', 'Password1', admin_role)
    find_or_create_user('member', 'member@example.com', 'Password1')

    # Add app-specific users
    find_or_create_user('checker', 'checker@example.com', 'Password1',
                        checker_role)
    find_or_create_user('endorser', 'endorser@example.com', 'Password1',
                        endorser_role)
    find_or_create_user('committee', 'committee@example.com', 'Password1',
                        committee_role)
    find_or_create_user('ceo', 'ceo@example.com', 'Password1',
                        ceo_role)
    find_or_create_user('manager', 'manager@example.com', 'Password1',
                        manager_role)
    find_or_create_user('processor', 'processor@example.com', 'Password1',
                        processor_role)
    find_or_create_user('payroll', 'payroll@example.com', 'Password1',
                        payroll_role)

    # app specific
    # the order is important; we rely on the 'id' column for sequence
    find_or_create_loan_status('submitted')
    find_or_create_loan_status('checked', 'checker')
    find_or_create_loan_status('endorsed', 'endorser')
    find_or_create_loan_status('verified', 'committee')
    find_or_create_loan_status('approved', 'ceo')
    find_or_create_loan_status('processed', 'processor')
    find_or_create_loan_status('released')
    find_or_create_loan_status('denied')

    # Save to DB
    db.session.commit()


# app specific
def find_or_create_loan_status(status_name, role_required=None):
    status = LoanStatus.query.filter(LoanStatus.status == status_name).first()
    if not status:
        status = LoanStatus(status=status_name, role_required=role_required)
        db.session.add(status)
    print(f"loan status {status_name} found or created")
    return status


# standard functions
def find_or_create_role(name, label):
    """Find existing role or create new role."""
    role = Role.query.filter(Role.name == name).first()
    if not role:
        role = Role(name=name, label=label)
        db.session.add(role)
    print('{} role found or created'.format(name))
    return role


def find_or_create_user(username, email, password, role=None):
    """Find existing user or create new user."""
    user = User.query.filter(User.email == email).first()
    if not user:
        user = User(username=username,
                    email=email,
                    password=current_app.user_manager.hash_password(password),
                    active=True,
                    email_confirmed_at=datetime.datetime.utcnow())
        if role:
            user.roles.append(role)
        db.session.add(user)
    print('user found or created')
    return user
