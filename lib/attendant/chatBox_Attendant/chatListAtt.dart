import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/Chat_Service/Chat_Screens/chatBox.dart';

class Chatlistatt extends StatelessWidget {
  final String attendantId;

  Chatlistatt({required this.attendantId});

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
                .where("attendantId", isEqualTo: attendantId)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              color: Color(0xffFFA500),
            ));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index].data() as Map<String, dynamic>;
              String chatId = chats[index].id;
              String userId = chatData["userId"];
              String userName = chatData["userName"];
              String userLocation = chatData["userLocation"];
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
                        : null, // ✅ Show unread count badge
                onTap: () async {
                  // ✅ Reset unread count when user opens chat
                  await FirebaseFirestore.instance
                      .collection("chats")
                      .doc(chatId)
                      .update({"unreadCount": 0});

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Chatbox(
                            senderId: attendantId,
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
