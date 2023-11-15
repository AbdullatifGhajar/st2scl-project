from .api import app
from .messenger import Messenger
from .models import Author, Message

if __name__ == "__main__":

    def add_testing_data():
        Author.add_author("Alice")
        Author.add_author("Bob")

        Message.add_message("Alice", "Bob", "Hello Bob!")
        Message.add_message("Bob", "Alice", "Hello Alice!")
        Message.add_message("Alice", "Bob", "How are you?")

    print("Creating testing data...")
    with app.app_context():
        add_testing_data()
        messenger = Messenger(Author.query.first())
        print(messenger.contacts)
