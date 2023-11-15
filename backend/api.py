import os
from datetime import datetime

from dotenv import load_dotenv
from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Load environment variables from .env file
load_dotenv()

db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_name = os.getenv("DB_NAME")
db_port = os.getenv("DB_PORT")


app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://{db_user}:{db_password}@localhost:{db_port}/{db_name}"

db = SQLAlchemy(app)
migrate = Migrate(app, db)


class Author(db.Model):
    username = db.Column(db.String(80), primary_key=True)

    def __init__(self, username: str):
        self.username = username

    @classmethod
    def add_author(cls, username: str):
        new_author = cls(username)
        db.session.add(new_author)
        db.session.commit()


# show timestamp in a natural way
def timestamp_to_string(timestamp):
    return datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M:%S")


class Message(db.Model):
    key = db.Column(db.Integer, primary_key=True, autoincrement=True)
    sender = db.Column(db.String(80), db.ForeignKey("author.username"))
    receiver = db.Column(db.String(80), db.ForeignKey("author.username"))
    content = db.Column(db.String(80), nullable=False)
    timestamp = db.Column(db.Integer, nullable=False, default=datetime.utcnow().timestamp())

    def __init__(self, sender: str, receiver: str, content: str):
        self.sender = sender
        self.receiver = receiver
        self.content = content

    def __str__(self):
        return f"[{timestamp_to_string(self.timestamp)}]: {self.sender} -> {self.receiver}: {self.content}"

    def __repr__(self):
        return self.__str__()

    # set timestamp to the key for sorting
    def __lt__(self, other):
        return self.timestamp < other.timestamp

    @classmethod
    def add_message(cls, sender: str, receiver: str, content: str):
        new_message = cls(sender, receiver, content)
        db.session.add(new_message)
        db.session.commit()


if __name__ == "__main__":

    def add_testing_data():
        Author.add_author("Alice")
        Author.add_author("Bob")

        Message.add_message("Alice", "Bob", "Hello Bob!")
        Message.add_message("Bob", "Alice", "Hello Alice!")
        Message.add_message("Alice", "Bob", "How are you?")

    with app.app_context():
        add_testing_data()
        print(Message.query.all())
        print(Author.query.all())
