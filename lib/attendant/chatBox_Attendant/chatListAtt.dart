import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/Chat_Service/Chat_Screens/chatBox.dart';

class Chatlistatt extends StatefulWidget {
  final String attendantId;

  Chatlistatt({required this.attendantId});

  @override
  State<Chatlistatt> createState() => _ChatlistattState();
}

class _ChatlistattState extends State<Chatlistatt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      appBar: AppBar(
        backgroundColor: Color(0xff0c0c0c),
        title: Text("Chats", style: TextStyle(fontFamily: 'Font1')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("chats")
                .where("attendantId", isEqualTo: widget.attendantId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xffFFA500)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Chats Yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index].data() as Map<String, dynamic>;

              String chatId = chats[index].id;
              String userId = chatData["userId"] ?? "Unknown";
              String userName = chatData["userName"] ?? "No Name";
              String userLocation =
                  chatData["userLocation"] ?? "Unknown Location";
              int unreadCount = chatData["unreadCount"] ?? 0;

              return ListTile(
                title: Text(userName, style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  "Location: $userLocation",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing:
                    unreadCount > 0
                        ? CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Text(
                            unreadCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                        : null,
                onTap: () async {
                  // Reset unread messages count
                  await FirebaseFirestore.instance
                      .collection("chats")
                      .doc(chatId)
                      .update({"unreadCount": 0});

                  // Navigate to chat screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatBox(
                            senderId: widget.attendantId,
                            receiverId: userId,
                            receiverName: userName,
                            chatId: chatId,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
