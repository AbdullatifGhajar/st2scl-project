import os

from dotenv import load_dotenv
from flask import Flask, jsonify
from flask_migrate import Migrate

from .models import Author, Message, db

app = Flask(__name__)

load_dotenv()

db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_name = os.getenv("DB_NAME")
db_port = os.getenv("DB_PORT")
db_container_name = os.getenv("DB_CONTAINER_NAME")

app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://{db_user}:{db_password}@postgres:{db_port}/{db_name}"

db.init_app(app)
migrate = Migrate(app, db)


@app.route("/")
def hello_world():
    try:
        return "Hello, World!"
    except Exception as e:
        return str(e)


@app.route("/generate")
def generate():
    def add_testing_data():
        Author.add_author("Alice")
        Author.add_author("Bob")

        Message.add_message("Alice", "Bob", "Hello Bob!")
        Message.add_message("Bob", "Alice", "Hello Alice!")
        Message.add_message("Alice", "Bob", "How are you?")

    with app.app_context():
        try:
            add_testing_data()
        except Exception as e:
            return str(e)
        finally:
            return str(Message.query.all())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
