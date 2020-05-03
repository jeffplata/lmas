# import jinja2
import flask

blueprint = flask.Blueprint('filters', __name__)


# @jinja2.contextfilter
@blueprint.app_template_filter('date')
def date1(date, format='short'):
    if format == 'long':
        return date.strftime('%B %-d, %Y')
    elif format == 'short':
        return date.strftime('%-m-%-d-%Y')
