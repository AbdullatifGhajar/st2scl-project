import os

from dotenv import load_dotenv
from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Load environment variables from .env file
load_dotenv()

postgres_username = os.getenv("POSTGRES_USER")
postgres_password = os.getenv("POSTGRES_PASSWORD")
postgres_db = os.getenv("POSTGRES_DB")


app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://{postgres_username}:{postgres_password}@172.17.0.1:5432/{postgres_db}"

db = SQLAlchemy(app)
migrate = Migrate(app, db)
