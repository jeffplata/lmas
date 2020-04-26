from app.main import bp
from flask import render_template


@bp.route('/', methods=['GET', 'POST'])
@bp.route('/index', methods=['GET', 'POST'])
def index():
    text = ""
    with open('README.md', 'r') as f:
        text = f.read()
    return render_template('index.html', text=text)
