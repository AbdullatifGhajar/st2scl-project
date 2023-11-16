from .models import Author, Message


class Messenger:
    def __init__(self, author: str):
        self.author = author
        self.contacts = self.retrieve_messages_grouped_by_other_contact(author)

    def retrieve_messages_grouped_by_other_contact(self, author: str):
        other_authors = Author.query.filter(Author.username != author).all()

        # for every other author, list all messages between them and the current author
        contacts = {}
        for other_author in other_authors:
            username = other_author.username
            messages = Message.query.filter(
                (Message.sender == author) | (Message.sender == username),
                (Message.receiver == author) | (Message.receiver == username),
            ).all()

            contacts[username] = [m.to_dict() for m in sorted(messages)]

        return contacts

    def send_message(self, receiver: str, message: str):
        Message.add_message(self.author, receiver, message)
        self.contacts = self.retrieve_messages_grouped_by_other_contact(self.author)
