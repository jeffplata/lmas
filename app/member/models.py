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


class AmortizationSchedule(db.Model):
	__abstract__ = True
	due_date = db.Column(db.Date())
	previous_balance = db.Column(db.Numeric(15,2))
	principal = db.Column(db.Numeric(15,2))
	interest = db.Column(db.Numeric(15,2))
	ideal_balance = db.Column(db.Numeric(15,2))