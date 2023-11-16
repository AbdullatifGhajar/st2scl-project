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
db_container_name = os.getenv("DB_CONTAINER_NAME")

# app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://{db_user}:{db_password}@postgres:{db_port}/{db_name}"

# db.init_app(app)
# migrate = Migrate(app, db)


@app.route("/", methods=["get"])
def hello_world():
    return f"Hello World! {db_user}"
