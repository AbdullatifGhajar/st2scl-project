import React, { useEffect, useState } from "react";
import styles from "@chatscope/chat-ui-kit-styles/dist/default/styles.min.css";
import {
    MainContainer,
    ChatContainer,
    MessageList,
    Message,
    MessageInput,
    Sidebar,
    Search,
    ConversationList,
    Conversation,
    ConversationHeader,
} from "@chatscope/chat-ui-kit-react";


const Chat = () => {
    const [author, setAuthor] = useState("Bob"); // TODO: change to current user
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
                    <Search placeholder="Search..." />
                    <ConversationList>
                        {messages &&
                            Object.keys(messages).map((author, index) => (
                                <Conversation
                                    name={author}
                                    lastSenderName={messages[author][messages[author].length - 1].sender}
                                    info={messages[author][messages[author].length - 1].content}
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
                            {/* iterate through the messages with currentConverstation. Set direction correcly (depends who is the sender) and all positions to single  */}
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
