import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              stream:
                  FirebaseFirestore.instance
                      .collection("chats")
                      .doc(widget.chatId)
                      .collection("messages")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
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
                          color:
                              isMe
                                  ? const Color.fromARGB(255, 112, 111, 111)
                                  : Color(0xffFFA500),
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
              suffixIconColor: Colors.orange, // Customize color
              onSuffixIconPressed:
                  _sendMessage, // Send message when send icon is pressed
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .add({
          "text": _messageController.text.trim(),
          "senderId": widget.senderId,
          "receiverId": widget.receiverId,
          "timestamp": Timestamp.now(),
        });

    _messageController.clear();
  }
}
