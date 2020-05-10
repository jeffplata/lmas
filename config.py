import os

from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))


class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = os.environ.get('SECRET_KEY') or \
        'you-will-never-guess-sfsdf-3fwesdt-adssewr-ssew232-sdae3-df334555'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') \
        or "<DATABASE_URL not set>"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = False

    # app specific settings
    DEFAULT_USR_PWD = os.environ.get('DEFAULT_USR_PWD') or 'Password1'

    # font-awesome settings
    FONTAWESOME_SERVE_LOCAL = True

    # flask-user settings
    USER_EMAIL_SENDER_EMAIL = "jeffflask@gmail.com"
    USER_APP_NAME = "LMAS"
    USER_ENABLE_CHANGE_USERNAME = False
    # flask-user  login mode settings
    USER_ENABLE_USERNAME = False
    USER_ALLOW_LOGIN_WITHOUT_CONFIRMED_EMAIL = True
    USER_ENABLE_CHANGE_PASSWORD = True
    USER_AFTER_LOGIN_ENDPOINT = 'main.dashboard'
    USER_AFTER_LOGOUT_ENDPOINT = 'user.login'

    MAIL_SERVER = os.environ.get('MAIL_SERVER')
    MAIL_PORT = int(os.environ.get('MAIL_PORT') or 25)
    MAIL_USE_TLS = os.environ.get('MAIL_USE_TLS') is not None
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER = os.environ.get('MAIL_DEFAULT_SENDER')
    ADMINS = ['jeffflask@gmail.com']


class ProductionConfig(Config):
    DEBUG = False


class StagingConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
