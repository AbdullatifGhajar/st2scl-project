from datetime import datetime

from api import db


class Contact:
    def __init__(self, author: "Author", messages: list):
        self.author = author
        self.messages = messages

    def __str__(self):
        return f"{self.author} ({len(self.messages)} messages)"

    def __repr__(self):
        return self.__repr__()


class Author(db.Model):
    username = db.Column(db.String(80), primary_key=True)

    def send_message(self, receiver: str, content: str):
        new_message = Message(self.username, receiver, content)
        db.session.add(new_message)
        db.session.commit()

    def retrieve_messages_grouped_by_receiver(self) -> [Contact]:
        messages = Message.query.filter_by(author=self.username).all()
        receivers = set([m.receiver for m in messages])
        contacts = []

        for receiver in receivers:
            contact = Contact(receiver, [m for m in messages if m.receiver == receiver])
            contacts.append(contact)

        return contacts


# show timestamp in a natural way
def timestamp_to_string(timestamp):
    return datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M:%S")


class Message(db.Model):
    author = db.Column(db.String(80), db.ForeignKey("author.username"), primary_key=True)
    receiver = db.Column(db.String(80), db.ForeignKey("author.username"), primary_key=True)
    content = db.Column(db.String(80), nullable=False)
    timestamp = db.Column(db.Integer, nullable=False, default=datetime.utcnow().timestamp())

    def __str__(self):
        return f"[{timestamp_to_string(self.timestamp)}]: {self.sender} -> {self.receiver}: {self.content}"

    def __repr__(self):
        return self.__repr__()

    # set timestamp to the key for sorting
    def __lt__(self, other):
        return self.timestamp < other.timestamp
