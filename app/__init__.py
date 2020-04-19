# import os

from config import Config

from flask import Flask
from flaskext.markdown import Markdown
from flask_bootstrap import Bootstrap

bootstrap = Bootstrap()


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    Markdown(app)
    bootstrap.init_app(app)

    # register blueprints
    with app.app_context():
        from app.main import bp as main_bp
        app.register_blueprint(main_bp)
        app.config['BOOTSTRAP_SERVE_LOCAL'] = True
    # appname = app.config['USER_APP_NAME']

    return app
