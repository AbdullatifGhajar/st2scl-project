import React, { useEffect, useState } from "react";

import styles from "@chatscope/chat-ui-kit-styles/dist/default/styles.min.css";
import {
    MainContainer,
    ChatContainer,
    MessageList,
    Message,
    MessageInput,
    Sidebar,
    Button,
    ConversationList,
    Conversation,
    ConversationHeader,
} from "@chatscope/chat-ui-kit-react";

import "./Chat.css";


const Chat = () => {
    const userList = ["Alice", "Bob", "Charlie"];

    const [author, setAuthor] = useState(userList[0]);
    const [messages, setMessages] = useState([]);
    const [messageInputValue, setMessageInputValue] = useState("");
    const [selectedConversation, setSelectedConversation] = useState(null);

    useEffect(() => {
        const fetchMessages = () => {
            fetch(`/api/get_messages?author=${author}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    setMessages(data);
                })
                .catch(error => {
                    console.error('Error fetching messages:', error);
                });
        };
        fetchMessages();
    }, [author]);

    function sendMessage() {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sender: author, receiver: selectedConversation, content: messageInputValue })
        };

        console.log(requestOptions);
        fetch('/api/send_message', requestOptions)
            .then(response => response.json())
            .then(data => {
                console.log(data)
                setMessages(data);
            });
    }


    return (
        <div style={{ height: "100vh" }}>
            <MainContainer responsive>
                <Sidebar position="left" scrollable={false}>
                    <div className="button-container">
                        {
                            userList.map((user) => (
                                <Button
                                    className={author === user ? "selected" : ""}
                                    onClick={() => { setAuthor(user); setSelectedConversation(null); }}
                                >
                                    {user}
                                </Button>
                            ))
                        }
                    </div>
                    <ConversationList>
                        {messages &&
                            Object.keys(messages).map((author, index) => (
                                <Conversation
                                    name={author}
                                    lastSenderName={messages[author].length ? messages[author][messages[author].length - 1].sender : "-"}
                                    info={messages[author].length ? messages[messages[author].length - 1].content : "-"}
                                    onClick={() => setSelectedConversation(author)}
                                >
                                </Conversation>
                            ))
                        }
                    </ConversationList>
                </Sidebar>

                {selectedConversation &&

                    <ChatContainer>
                        <ConversationHeader>
                            <ConversationHeader.Back />
                            <ConversationHeader.Content
                                userName={selectedConversation}
                            />
                        </ConversationHeader>
                        <MessageList>
                            {messages[selectedConversation].map((message, index) => (
                                <Message
                                    model={{
                                        message: message.content,
                                        sender: message.sender,
                                        direction: message.sender === selectedConversation ? "incoming" : "outgoing",
                                        position: "single"
                                    }}
                                >
                                </Message>
                            ))}

                        </MessageList>
                        <MessageInput
                            placeholder="Type message here"
                            value={messageInputValue}
                            onChange={(val) => setMessageInputValue(val)}
                            onSend={() => { sendMessage(); setMessageInputValue(""); }}
                            attachButton={false}
                        />
                    </ChatContainer>
                }
            </MainContainer>
        </div>
    );
};

export default Chat;
