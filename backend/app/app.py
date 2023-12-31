import os

from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate

from .messenger import Messenger
from .models import Author, Message, db

app = Flask(__name__)

CORS(app)

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


@app.route("/get_messages")
def get_messages():
    author = request.args.get("author")
    messenger = Messenger(author)

    return jsonify(messenger.contacts)

@app.route("/send_message", methods=["POST"])
def send_message():
    data = request.get_json()
    
    sender = data["sender"]
    messenger = Messenger(sender)

    messenger.send_message(data["receiver"], data["content"])

    return jsonify(messenger.contacts)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
