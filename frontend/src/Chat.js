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
    Avatar,
    ConversationList,
    Conversation,
    ConversationHeader,
    Search,
    VoiceCallButton,
    VideoCallButton,
    InfoButton,
} from "@chatscope/chat-ui-kit-react";

import "./Chat.css";

const mockAvatar = <Avatar src={"https://png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg"} />;

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

    const sendMessage = () => {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sender: author, receiver: selectedConversation, content: messageInputValue })
        };

        fetch('/api/send_message', requestOptions)
            .then(response => response.json())
            .then(data => {
                console.log(data)
                setMessages(data);
            });
    }

    const mockLastSeen = (author) => {
        // return the sum of all letters in the author's name
        return author.split("").reduce((acc, curr) => acc + curr.charCodeAt(0), 0) % 24 + 1;
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
                    <Search placeholder="Search" />
                    <ConversationList>
                        {messages &&
                            Object.keys(messages).map((author, index) => (
                                <Conversation
                                    name={author}
                                    info={messages[author].length !== 0 ? messages[author][messages[author].length - 1].content : ""}
                                    onClick={() => setSelectedConversation(author)}
                                    lastActivityTime={`${mockLastSeen(author)}h`}
                                >
                                    {mockAvatar}
                                </Conversation>
                            ))
                        }
                    </ConversationList>
                </Sidebar>

                {selectedConversation &&
                    <ChatContainer>
                        <ConversationHeader>
                            <ConversationHeader.Back />
                            {mockAvatar}
                            <ConversationHeader.Content
                                userName={selectedConversation}
                                info={`Last seen online ${mockLastSeen(selectedConversation)} hours ago`}
                            />
                            <ConversationHeader.Actions>
                                <VoiceCallButton />
                                <VideoCallButton />
                                <InfoButton />
                            </ConversationHeader.Actions>

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
                            attachButton={true}
                        />
                    </ChatContainer>
                }
            </MainContainer>
        </div>
    );
};

export default Chat;
