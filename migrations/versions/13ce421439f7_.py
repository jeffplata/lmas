"""empty message

Revision ID: 13ce421439f7
Revises: 52e77bf6a7c0
Create Date: 2020-04-26 11:38:44.075856

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '13ce421439f7'
down_revision = '52e77bf6a7c0'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('auth_user_detail',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('date_created', sa.DateTime(), nullable=True),
    sa.Column('date_modified', sa.DateTime(), nullable=True),
    sa.Column('user_id', sa.Integer(), nullable=True),
    sa.Column('last_name', sa.String(length=128), nullable=False),
    sa.Column('first_name', sa.String(length=128), nullable=True),
    sa.Column('middle_name', sa.String(length=128), nullable=True),
    sa.Column('suffix', sa.String(length=20), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['auth_user.id'], ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('auth_user_detail')
    # ### end Alembic commands ###