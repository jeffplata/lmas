# import os

from config import Config
# from app.user_models import User

from flask import Flask
from flaskext.markdown import Markdown
from flask_bootstrap import Bootstrap
from flask_fontawesome import FontAwesome
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_user import UserManager
from flask_mail import Mail
from flask_babel import Babel


bootstrap = Bootstrap()
fa = FontAwesome()
db = SQLAlchemy()

from app.user_models import User

migrate = Migrate()
mail = Mail()
babel = Babel()


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    Markdown(app)
    bootstrap.init_app(app)
    fa.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)
    UserManager(app, db, User)
    mail.init_app(app)
    babel.init_app(app)

    # register blueprints
    with app.app_context():
        from app.main import bp as main_bp
        app.register_blueprint(main_bp)
        app.config['BOOTSTRAP_SERVE_LOCAL'] = True

        from app.filters import blueprint as filters_bp
        app.register_blueprint(filters_bp)

        from app.member import bp as member_bp
        app.register_blueprint(member_bp)

        from app.fadmin import bp as fadmin_bp
        app.register_blueprint(fadmin_bp)
        from app.fadmin.controller import admin
        admin.init_app(app)

        # from flask_mail import Message

        # msg = Message(subject="Hello",
        #               sender="jeffflask@gmail.com",
        #               recipients=["jeffflask@gmail.com"],
        #               body="This is a test email I sent with Gmail and Python!")
        # mail.send(msg)

    return app

# user_manager = create_app().user_manager
