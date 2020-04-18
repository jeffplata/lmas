# import os

from config import Config

from flask import Flask


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # register blueprints
    with app.app_context():
        from app.main import bp as main_bp
        app.register_blueprint(main_bp)

    # appname = app.config['USER_APP_NAME']

    return app
