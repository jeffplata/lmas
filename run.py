"""main app."""

from app import create_app

from config import DevelopmentConfig

myapp = create_app(DevelopmentConfig)


if __name__ == "__main__":
    myapp.run(debug=True)
