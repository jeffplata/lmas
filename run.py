"""main app."""


from app import create_app
from config import DevelopmentConfig

myapp = create_app(DevelopmentConfig)


if __name__ == "__main__":
    myapp.run(debug=True)

"""
Lessons:
Sunday, 19 April, 2020 06:45:49 PM PST

when deploying on heroku, do not name everything "app".
Flask app file: run.py
Application package: app (folder)
Application instance: myapp

Heroku Procfile contents: web gunicorn run:myapp ...
"""
