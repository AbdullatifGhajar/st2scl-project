import React, { useState } from "react";
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
    // Set initial message input value to empty string
    const [messageInputValue, setMessageInputValue] = useState("");

    const messages = {
        "Alice": [
            {
                "content": "Hello Bob!",
                "receiver": "Bob",
                "sender": "Alice",
                "timestamp": 1700133515
            },
            {
                "content": "Hello Alice!",
                "receiver": "Alice",
                "sender": "Bob",
                "timestamp": 1700133515
            },
            {
                "content": "How are you?",
                "receiver": "Bob",
                "sender": "Alice",
                "timestamp": 1700133515
            }
        ]
    }

    const [selectedConversation, setSelectedConversation] = useState(null);

    return (
        <div style={{ height: "100vh" }}>
            <MainContainer responsive>
                <Sidebar position="left" scrollable={false}>
                    <Search placeholder="Search..." />
                    <ConversationList>
                        {Object.keys(messages).map((author, index) => (
                            <Conversation
                                name={author}
                                lastSenderName={messages[author][messages[author].length - 1].sender}
                                info={messages[author][messages[author].length - 1].content}
                                onClick={() => setSelectedConversation(author)}
                            >
                            </Conversation>
                        ))}
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
                            onSend={() => setMessageInputValue("")}
                            attachButton={false}
                        />
                    </ChatContainer>
                }
            </MainContainer>
        </div>
    );
};

export default Chat;
