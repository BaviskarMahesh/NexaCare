import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';
import 'package:nexacare/Chat_Service/reposiory/chat_message_implementation.dart';
import 'package:nexacare/utils/textfield.dart';

class ChatBox extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String chatId;

  const ChatBox({
    Key? key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.chatId,
  }) : super(key: key);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _messageController = TextEditingController();
  final ChatRepositoryImpl _chatRepository = ChatRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.receiverName, style: TextStyle(fontFamily: 'Font1')),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("chats")
              .doc(widget.chatId)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No messages yet",
              style: TextStyle(fontFamily: 'Font1', color: Colors.white),
            ),
          );
        }

        var messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index].data() as Map<String, dynamic>;
            bool isMe = message["senderId"] == widget.senderId;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.grey[700] : Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message["text"],
                  style: TextStyle(fontFamily: 'Font1', color: Colors.white),
                ),
              ),
            );
          },
        );
      },
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
              hintStyle: TextStyle(
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
      MessageEntity message = MessageEntity(
        chatId: widget.chatId,
        text: _messageController.text.trim(),
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        timestamp: DateTime.now(),
      );

      await _chatRepository.sendMessage(message, widget.chatId);
      _messageController.clear();
    }
  }
}
