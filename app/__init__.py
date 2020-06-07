import os
import logging
from logging.handlers import SMTPHandler, RotatingFileHandler
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
import flask_excel as excel


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
    excel.init_excel(app)

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

        # msg = Message(
        #     subject="Hello",
        #     sender="jeffflask@gmail.com",
        #     recipients=["jeffflask@gmail.com"],
        #     body="This is a test email I sent with Gmail and Python!")
        # mail.send(msg)

        appname = app.config['USER_APP_NAME']

        if not app.debug and not app.testing:
            if app.config['MAIL_SERVER']:
                auth = None
                if app.config['MAIL_USERNAME'] or app.config['MAIL_PASSWORD']:
                    auth = (app.config['MAIL_USERNAME'],
                            app.config['MAIL_PASSWORD'])
                secure = None
                if app.config['MAIL_USE_TLS']:
                    secure = ()
                mail_handler = SMTPHandler(
                    mailhost=(app.config['MAIL_SERVER'],
                              app.config['MAIL_PORT']),
                    fromaddr='no-reply@' + app.config['MAIL_SERVER'],
                    toaddrs=app.config['ADMINS'],
                    subject=appname + ' Failure',
                    credentials=auth, secure=secure)
                mail_handler.setLevel(logging.ERROR)
                app.logger.addHandler(mail_handler)

            if not os.path.exists('logs'):
                os.mkdir('logs')
            file_handler = RotatingFileHandler('logs/' + appname + '.log',
                                               maxBytes=10240, backupCount=10)
            file_handler.setFormatter(logging.Formatter(
                '%(asctime)s %(levelname)s: %(message)s '
                '[in %(pathname)s:%(lineno)d]'))
            file_handler.setLevel(logging.INFO)
            app.logger.addHandler(file_handler)

            app.logger.setLevel(logging.INFO)
            app.logger.info(appname + ' startup')

    return app

# user_manager = create_app().user_manager
