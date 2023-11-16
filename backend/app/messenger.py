from .models import Author, Message


class Contact:
    def __init__(self, author: Author, messages: [Message]):
        self.author = author
        self.messages = messages

    def __str__(self):
        return f"{self.author} ({len(self.messages)} messages)"

    def __repr__(self):
        return self.__str__()


class Messenger:
    def __init__(self, author: Author):
        self.author = author
        self.contacts = self.retrieve_messages_grouped_by_receiver(author)

    def retrieve_messages_grouped_by_receiver(self, author: Author):
        messages = Message.query.filter_by(sender=author.username).all()
        receivers = set([m.receiver for m in messages])
        contacts = []

        for receiver in receivers:
            contact = Contact(receiver, [m for m in messages if m.receiver == receiver])
            contacts.append(contact)

        return contacts
