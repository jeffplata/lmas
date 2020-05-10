import flask

blueprint = flask.Blueprint('filters', __name__)


@blueprint.app_template_filter('date')
def date1(date, format='short'):
    if format == 'long':
        return date.strftime('%B %-d, %Y')
    elif format == 'short':
        return date.strftime('%-m-%-d-%Y')


@blueprint.app_template_filter('money')
def money_filter(amount, total=''):
    if total:
        return total
    return "{:,.2f}".format(amount)
