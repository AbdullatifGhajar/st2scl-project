import os

from dotenv import load_dotenv
from flask import Flask
from flask_migrate import Migrate

from .models import Author, Message, db

app = Flask(__name__)

load_dotenv()

db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_name = os.getenv("DB_NAME")
db_port = os.getenv("DB_PORT")

app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://{db_user}:{db_password}@localhost:{db_port}/{db_name}"

db.init_app(app)
migrate = Migrate(app, db)

if __name__ == "__main__":
    app.run()
