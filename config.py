import os
# basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') \
        or "<DATABASE_URL not set>"
    SQLALCHEMY_TRACK_MODIFICATIONS = True

    # flask-user settings
    USER_EMAIL_SENDER_EMAIL = "jeffflask@gmail.com"
    USER_APP_NAME = "LMAS"
    USER_ENABLE_CHANGE_USERNAME = False


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
