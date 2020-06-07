"""empty message

Revision ID: b1f5cd774764
Revises: abbf639b988b
Create Date: 2020-06-06 07:14:15.770567

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b1f5cd774764'
down_revision = 'abbf639b988b'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint('member_salary_user_id_fkey', 'member_salary', type_='foreignkey')
    op.create_foreign_key(None, 'member_salary', 'auth_user_detail', ['user_id'], ['id'], ondelete='CASCADE')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'member_salary', type_='foreignkey')
    op.create_foreign_key('member_salary_user_id_fkey', 'member_salary', 'auth_user', ['user_id'], ['id'], ondelete='CASCADE')
    # ### end Alembic commands ###
