from app import db
from app.user_models import Base
from sqlalchemy.ext.hybrid import hybrid_property
from datetime import datetime
# from sqlalchemy import select, and_, outerjoin
# from sqlalchemy.orm import aliased


class UserDetail(Base):
    __tablename__ = "auth_user_detail"
    user_id = db.Column(db.Integer())
    # user_id = db.Column(db.Integer(),
    #                     db.ForeignKey('auth_user.id', ondelete='CASCADE'),
    #                     unique=True)
    last_name = db.Column(db.String(128), nullable=False)
    first_name = db.Column(db.String(128))
    middle_name = db.Column(db.String(128))
    suffix = db.Column(db.String(20))
    employee_number = db.Column(db.String(20),
                                db.ForeignKey('auth_user.employee_number',
                                              ondelete='CASCADE'),
                                unique=True)
    email = db.Column(db.String(128))

    user = db.relationship('User', uselist=False, backref='auth_user_detail')
    salary = db.relationship('MemberSalary', uselist=False,
                             backref='auth_user_detail')
    salary_history = db.relationship('MemberSalaryHistory', uselist=False,
                                     backref='auth_user_detail')

    db.UniqueConstraint(last_name, first_name, middle_name, suffix)

    @hybrid_property
    def full_name(self):
        return "{}{}{}{}".format(
            self.first_name,
            " " + self.middle_name if self.middle_name else "",
            " " + self.last_name if self.last_name else "",
            " " + self.suffix if self.suffix else "")

    @full_name.expression
    def full_name(cls):
        return cls.last_name + cls.first_name + cls.middle_name + cls.suffix

    def __repr__(self):
        return "User [{}] {}, {}".format(self.user_id, self.last_name,
                                         self.first_name)

    def __str__(self):
        return "{}{}".format(
            self.last_name,
            ", " + self.first_name if self.first_name else "")


class MemberSalary(Base):
    __tablename__ = "member_salary"
    user_detail_id = db.Column(
        db.Integer(),
        db.ForeignKey('auth_user_detail.id', ondelete='CASCADE'),
        unique=True)
    effective_date = db.Column(db.Date(), default=datetime.utcnow())
    sg = db.Column(db.Integer())
    step = db.Column(db.Integer())
    salary = db.Column(db.Numeric(15, 2))


class MemberSalaryHistory(Base):
    __tablename__ = "member_salary_history"
    user_detail_id = db.Column(
        db.Integer(),
        db.ForeignKey('auth_user_detail.id', ondelete='CASCADE'))
    effective_date = db.Column(db.Date(), default=datetime.utcnow())
    sg = db.Column(db.Integer())
    step = db.Column(db.Integer())
    salary = db.Column(db.Numeric(15, 2))


# newer_salaries = aliased(MemberSalary)

# latest_salaries_query = select([MemberSalary]).\
#     select_from(
#         outerjoin(MemberSalary, newer_salaries,
#                   and_(newer_salaries.user_detail_id ==
#                        MemberSalary.user_detail_id,
#                        newer_salaries.id > MemberSalary.id))).\
#     where(newer_salaries.id == None).\
#     alias()

# latest_salaries = aliased(MemberSalary, latest_salaries_query)

# UserDetail.salary = db.relationship(
#     latest_salaries, uselist=False, viewonly=True)


class SalaryGrade(Base):
    __tablename__ = 'salary_grade'
    sg = db.Column(db.Integer(), nullable=False)
    step = db.Column(db.Integer(), nullable=False)
    salary = db.Column(db.Numeric(15, 2))
    group_name = db.Column(db.String(128))
    active = db.Column(db.Boolean(), default=True)

    @classmethod
    def all_active(cls, all_active=True):
        if all_active:
            return cls.query.filter_by(
                active=True).order_by(cls.sg, cls.step).all()
        else:
            return cls.query.filter(
                cls.active.isnot(True)).order_by(cls.sg, cls.step).all()

    @classmethod
    def set_active(cls, active=True):
        cls.active = active


class Service(Base):
    __tablename__ = 'service'
    name = db.Column(db.String(128), nullable=False, unique=True)
    description = db.Column(db.String(128))
    interest_rate = db.Column(db.Numeric(15, 2), nullable=False)
    min_term = db.Column(db.Integer(), nullable=False)
    max_term = db.Column(db.Integer(), nullable=False)

    active = db.Column(db.Boolean(), default=True)


class Contribution(Base):
    __tablename__ = 'contribution'
    employee_number = db.Column(db.String(20),
                                db.ForeignKey('auth_user.employee_number',
                                              ondelete='CASCADE'))
    trans_date = db.Column(db.Date())
    period = db.Column(db.Date())
    amount = db.Column(db.Numeric(15, 2))
    contributor = db.Column(db.String(1), nullable=False)
    # M = Member, E = Employer
    trans_type = db.Column(db.String(3), nullable=False)
    # REG = Regular, DIF = Differential


class Loan(Base):
    __tablename__ = 'loan'
    service_id = db.Column(db.Integer(),
                           db.ForeignKey(
                           'service.id', ondelete='CASCADE'))
    user_id = db.Column(db.Integer(),
                        db.ForeignKey(
                        'auth_user.id', ondelete='CASCADE'))
    date_filed = db.Column(db.DateTime, default=db.func.current_timestamp())
    amount = db.Column(db.Numeric(15, 2), nullable=False)
    terms = db.Column(db.Integer(), nullable=False)
    interest_rate = db.Column(db.Numeric(15, 2))
    previous_balance = db.Column(db.Numeric(15, 2))
    processing_fee = db.Column(db.Numeric(15, 2))
    net_proceeds = db.Column(db.Numeric(15, 2), nullable=False)
    first_due_date = db.Column(db.Date(), nullable=False)
    last_due_date = db.Column(db.Date())
    memberbank_id = db.Column(db.Integer())
    status = db.Column(db.String(20))

    user = db.relationship('User', uselist=False, backref='loan')
    service = db.relationship('Service', uselist=False)
    # the bank reference is only for convenience
    #    user can remove his bank detail anytime

    def __repr__(self):
        return f"{self.user.detail.last_name} {self.user.detail.first_name}, "\
               f"{self.service.name}, {self.amount} [{self.id}]"


class LoanStatus(Base):
    __tablename__ = 'loan_status'
    status = db.Column(db.String(20), unique=True)
    role_required = db.Column(db.String(50))


class LoanPaymentBatch(Base):
    __tablename__ = 'loan_payment_batch'
    trans_date = db.Column(db.Date())
    description = db.Column(db.String(128))


class LoanPayment(Base):
    __tablename__ = 'loan_payment'
    batch_id = db.Column(db.Integer(),
                         db.ForeignKey(
                         'loan_payment_batch.id', ondelete='CASCADE'))
    loan_id = db.Column(db.Integer(),
                        db.ForeignKey(
                        'loan.id', ondelete='CASCADE'),
                        nullable=False)
    amount_paid = db.Column(db.Numeric(15, 2))

    batch = db.relationship('LoanPaymentBatch', uselist=False,
                            backref='loan_payment')
    loan = db.relationship('Loan', uselist=False, backref='loan_payment')


class AmortizationSchedule(db.Model):
    __abstract__ = True
    due_date = db.Column(db.Date())
    previous_balance = db.Column(db.Numeric(15, 2))
    principal = db.Column(db.Numeric(15, 2))
    interest = db.Column(db.Numeric(15, 2))
    ideal_balance = db.Column(db.Numeric(15, 2))


class Bank(Base):
    __tablename__ = 'bank'
    short_name = db.Column(db.String(20), nullable=False, unique=True)
    name = db.Column(db.String(128), nullable=False, unique=True)
    active = db.Column(db.Boolean(), default=True)

    @classmethod
    def all_active(cls, all_active=True):
        if all_active:
            return cls.query.filter_by(active=True).all()
        else:
            return cls.query.filter(cls.active.isnot(True)).all()

    def __repr__(self):
        return '<Bank %r>' % (self.short_name)


class MemberBank(Base):
    __tablename__ = 'member_bank'
    bank_id = db.Column(db.Integer(),
                        db.ForeignKey('bank.id', ondelete='CASCADE'))
    user_id = db.Column(db.Integer(),
                        db.ForeignKey('auth_user.id', ondelete='CASCADE'))
    account_number = db.Column(db.String(128), nullable=False)
    account_name = db.Column(db.String(128), nullable=False)

    bank = db.relationship('Bank', uselist=False, backref='bank')
    user = db.relationship('User', uselist=False, backref='auth_user')

    # implement unique check at client: bank_id+user_id+account_number
    def is_unique_record(self):
        match_found = MemberBank.query.filter_by(
            user_id=self.user_id,
            bank_id=self.bank_id,
            account_number=self.account_number).all()

        if match_found:
            if len(match_found) > 1:
                return False
            else:
                return (match_found[0].id == self.id)
        else:
            return True

    def __repr__(self):
        return "MB {},{},{},{}".format(
            self.user_id,
            self.bank_id,
            self.account_number,
            self.account_name)
