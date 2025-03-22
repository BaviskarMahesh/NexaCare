import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';
import 'package:nexacare/Chat_Service/reposiory/chat_message_implementation.dart';
import 'package:nexacare/utils/textfield.dart';

class Chatbox extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String chatId;

  Chatbox({
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.chatId,
  });

  @override
  _ChatboxState createState() => _ChatboxState();
}

class _ChatboxState extends State<Chatbox> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatRepositoryImpl _chatRepository = ChatRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.receiverName,
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print("No messages found for chatId: ${widget.chatId}");
                  return Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(fontFamily: 'Font1'),
                    ),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data() as Map<String, dynamic>;
                    if (!message.containsKey("text") ||
                        !message.containsKey("senderId") ||
                        !message.containsKey("timestamp")) {
                      print("Skipping message due to missing fields: $message");
                      return SizedBox.shrink();
                    }

                    bool isMe = message["senderId"] == widget.senderId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.grey[700] : Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message["text"],
                          style: TextStyle(
                            fontFamily: 'Font1',
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextfieldUtil.customTextField(
              controller: _messageController,
              hintText: "Type a message...",
              hintStyle: const TextStyle(
                fontFamily: 'Font1',
                color: Color.fromARGB(255, 164, 159, 159),
              ),
              suffixIcon: Icons.send,
              suffixIconColor: Colors.orange,
              onSuffixIconPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      print("Sending message to chatId: ${widget.chatId}");

      MessageEntity message = MessageEntity(
        chatId: widget.chatId,
        text: _messageController.text.trim(),
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        timestamp: DateTime.now(),
      );

      await _chatRepository.sendMessage(message, widget.chatId);
      
      setState(() {}); // Force UI update
      _messageController.clear();
    }
  }
}
