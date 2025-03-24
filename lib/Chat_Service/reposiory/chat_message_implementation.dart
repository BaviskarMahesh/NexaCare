import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';
import 'package:nexacare/Chat_Service/Model/chat_message_model.dart';
import 'package:nexacare/Chat_Service/reposiory/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _generateChatId(String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    return ids.join("_");
  }

  @override
  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    String chatId = _generateChatId(senderId, receiverId);

    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true) // ✅ Show newest messages first
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromJson(doc.data(), id: doc.id))
                  .toList(),
        );
  }

  @override
  Future<void> sendMessage(MessageEntity message, String receiverId) async {
    try {
      String senderId = _auth.currentUser!.uid;
      String chatId = _generateChatId(senderId, receiverId);

      DocumentReference chatDocRef = _firestore.collection("chats").doc(chatId);
      CollectionReference messagesRef = chatDocRef.collection("messages");

      DocumentReference newMessageDocRef =
          messagesRef.doc(); // ✅ Generate ID first

      MessageModel messageModel = MessageModel(
        id: newMessageDocRef.id,
        chatId: chatId,
        text: message.text,
        senderId: senderId,
        receiverId: receiverId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        read: false,
      );

      await newMessageDocRef.set(messageModel.toJson()); // ✅ Save with ID

      await chatDocRef.set({
        "userId": senderId,
        "receiverId": receiverId,
        "lastMessage": message.text,
        "lastMessageTime": Timestamp.now(),
      }, SetOptions(merge: true));

      await _incrementUnreadCount(chatDocRef, receiverId);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Future<void> markMessagesAsRead(String userId, String attendantId) async {
    try {
      String chatId = _generateChatId(userId, attendantId);
      DocumentReference chatDocRef = _firestore.collection("chats").doc(chatId);

      await chatDocRef.set({"unread_$userId": 0}, SetOptions(merge: true));

      QuerySnapshot unreadMessages =
          await chatDocRef
              .collection("messages")
              .where("receiverId", isEqualTo: userId)
              .where("read", isEqualTo: false)
              .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {"read": true});
      }
      await batch.commit();
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  Future<void> _incrementUnreadCount(
    DocumentReference chatDocRef,
    String receiverId,
  ) async {
    try {
      DocumentSnapshot chatDoc = await chatDocRef.get();
      if (!chatDoc.exists) {
        await chatDocRef.set({
          "unread_$receiverId": 1,
        }, SetOptions(merge: true));
        return;
      }

      Map<String, dynamic>? data = chatDoc.data() as Map<String, dynamic>?;
      int unreadCount = (data?["unread_$receiverId"] ?? 0) + 1;

      await chatDocRef.set({
        "unread_$receiverId": unreadCount,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating unread count: $e");
    }
  }
}
