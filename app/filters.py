import flask
from datetime import datetime
from dateutil.relativedelta import relativedelta


blueprint = flask.Blueprint('filters', __name__)


@blueprint.app_template_filter('date')
def date1(date, format='short'):
    if format == 'long':
        return date.strftime('%B %d, %Y')
    elif format == 'short':
        return date.strftime('%m/%d/%Y')


@blueprint.app_template_filter('money')
def money_filter(amount, total=''):
    if total:
        return total
    return "{:,.2f}".format(amount)


@blueprint.app_template_filter('pluralize')
def pluralize(number, singular='', plural='s'):
    if number == 1:
        return singular
    else:
        return plural


@blueprint.app_template_filter('days_ago')
def days_ago(date):
    today = datetime.now()
    age = relativedelta(today, date)
    years = age.years
    months = age.months
    days = age.days
    hours = age.hours
    minutes = age.minutes
    if years:
        s = str(years) + (' years' if years > 1 else ' year')
    elif months:
        s = str(months) + (' months' if months > 1 else ' month')
    elif days:
        s = str(days) + (' days' if days > 1 else ' day')
    elif hours:
        s = str(hours) + (' hours' if hours > 1 else ' hour')
    elif minutes:
        s = str(minutes) + (' minutes' if minutes > 1 else ' minute')
    else:
        s = 'A few seconds '
    return s + ' ago'
