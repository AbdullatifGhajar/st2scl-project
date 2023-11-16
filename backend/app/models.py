from datetime import datetime

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Author(db.Model):
    username = db.Column(db.String(80), primary_key=True)

    def __init__(self, username: str):
        self.username = username

    @classmethod
    def add_author(cls, username: str):
        new_author = cls(username)
        db.session.add(new_author)
        db.session.commit()


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

    def __lt__(self, other):
        return self.timestamp < other.timestamp

    @classmethod
    def add_message(cls, sender: str, receiver: str, content: str):
        new_message = cls(sender, receiver, content)
        db.session.add(new_message)
        db.session.commit()
