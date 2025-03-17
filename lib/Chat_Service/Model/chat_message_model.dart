import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    String? id, // Optional message ID
    required String chatId, // Chat ID to identify conversation
    required String text,
    required String senderId,
    required String receiverId,
    required Timestamp timestamp,
    bool read = false,
  }) : super(
          id: id,
          chatId: chatId,
          text: text,
          senderId: senderId,
          receiverId: receiverId,
          timestamp: timestamp.toDate(),
          read: read,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MessageModel(
      id: id,
      chatId: json["chatId"] ?? "",
      text: json["text"] ?? "",
      senderId: json["senderId"] ?? "",
      receiverId: json["receiverId"] ?? "",
      timestamp: json["timestamp"] ?? Timestamp.now(),
      read: json["read"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "text": text,
      "senderId": senderId,
      "receiverId": receiverId,
      "timestamp": Timestamp.fromDate(timestamp),
      "read": read,
    };
  }

  MessageModel copyWith({String? id}) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId,
      text: text,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: Timestamp.fromDate(timestamp),
      read: read,
    );
  }
}
