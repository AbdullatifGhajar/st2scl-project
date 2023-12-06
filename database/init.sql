-- Create tables 
CREATE TABLE Author (
    username VARCHAR(80) PRIMARY KEY
);

CREATE TABLE Message (
    key SERIAL PRIMARY KEY,
    sender VARCHAR(80),
    receiver VARCHAR(80),
    content VARCHAR(80) NOT NULL,
    timestamp BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW()),

    FOREIGN KEY (sender) REFERENCES Author(username),
    FOREIGN KEY (receiver) REFERENCES Author(username)
);

-- Add test data
INSERT INTO Author (username) VALUES ('Alice');
INSERT INTO Author (username) VALUES ('Bob');
INSERT INTO Author (username) VALUES ('Charlie');
INSERT INTO Author (username) VALUES ('David');

INSERT INTO Message (sender, receiver, content) VALUES ('Alice', 'Bob', 'Hello Bob!');
INSERT INTO Message (sender, receiver, content) VALUES ('Alice', 'Bob', 'How are you?');

INSERT INTO Message (sender, receiver, content) VALUES ('Bob', 'Alice', 'Hello Alice!');

INSERT INTO Message (sender, receiver, content) VALUES ('Bob', 'Charlie', 'Hello Charlie!');
INSERT INTO Message (sender, receiver, content) VALUES ('Charlie', 'Bob', 'Hello Bob! 😊');
INSERT INTO Message (sender, receiver, content) VALUES ('Bob', 'Charlie', 'How are you?');
INSERT INTO Message (sender, receiver, content) VALUES ('Charlie', 'Bob', 'I''m fine, thanks!');

INSERT INTO Message (sender, receiver, content) VALUES ('Bob', 'David', 'Hello David!');
INSERT INTO Message (sender, receiver, content) VALUES ('David', 'Bob', 'Hello Bob!');
