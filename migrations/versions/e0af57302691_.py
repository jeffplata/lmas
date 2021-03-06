"""empty message

Revision ID: e0af57302691
Revises: 5f28293d859d
Create Date: 2020-09-17 00:49:26.581879

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'e0af57302691'
down_revision = '5f28293d859d'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('Contribution',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('date_created', sa.DateTime(), nullable=True),
    sa.Column('date_modified', sa.DateTime(), nullable=True),
    sa.Column('employee_number', sa.String(length=20), nullable=True),
    sa.Column('trans_date', sa.Date(), nullable=True),
    sa.Column('period', sa.Date(), nullable=True),
    sa.Column('amount', sa.Numeric(precision=15, scale=2), nullable=True),
    sa.Column('contributor', sa.String(length=1), nullable=False),
    sa.Column('trans_type', sa.String(length=3), nullable=False),
    sa.ForeignKeyConstraint(['employee_number'], ['auth_user.employee_number'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('Contribution')
    # ### end Alembic commands ###
