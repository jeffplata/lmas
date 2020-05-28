from app import db
from app.user_models import Base


class Service(Base):
    __tablename__ = 'service'
    name = db.Column(db.String(128), nullable=False, unique=True)
    description = db.Column(db.String(128))
    interest_rate = db.Column(db.Numeric(15, 2), nullable=False)
    min_term = db.Column(db.Integer(), nullable=False)
    max_term = db.Column(db.Integer(), nullable=False)

    active = db.Column(db.Boolean(), default=True)


class Loan(Base):
    # __abstract__ = True
    __tablename__ = 'loan'
    service_id = db.Column(db.Integer(),
                           db.ForeignKey(
                           'service.id', ondelete='CASCADE'))
    user_id = db.Column(db.Integer(),
                        db.ForeignKey(
                        'auth_user.id', ondelete='CASCADE'))
    amount = db.Column(db.Numeric(15, 2), nullable=False)
    terms = db.Column(db.Integer(), nullable=False)
    interest_rate = db.Column(db.Numeric(15, 2))
    previous_balance = db.Column(db.Numeric(15, 2))
    processing_fee = db.Column(db.Numeric(15, 2))
    net_proceeds = db.Column(db.Numeric(15, 2), nullable=False)
    first_due_date = db.Column(db.Date(), nullable=False)
    last_due_date = db.Column(db.Date())
    memberbank_id = db.Column(db.Integer())
    # the bank reference is only for convenience
    #    user can remove his bank detail anytime

    def __repr__(self):
        return '<Loan %r>' % (self.amount)
        # return '<Loan {}, {}>'.format(self.user)


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
    def unique_record(self):
        match_found = MemberBank.query.filter_by(
            user_id=self.user_id,
            bank_id=self.bank_id,
            account_number=self.account_number).first()

        if match_found:
            # it may have found itself
            return (match_found.id != self.id)
        return True
