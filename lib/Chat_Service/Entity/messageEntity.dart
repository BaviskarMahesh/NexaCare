import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? id;
  final String chatId; // Chat identifier
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool read;

  const MessageEntity({
    this.id,
    required this.chatId,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.read = false,
  });

  // Convert MessageEntity to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp.millisecondsSinceEpoch, // Store timestamp as an int
      'read': read,
    };
  }

  // Create a MessageEntity from Firestore Map
  factory MessageEntity.fromMap(Map<String, dynamic> map, String documentId) {
    return MessageEntity(
      id: documentId,
      chatId: map['chatId'] ?? '',
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      read: map['read'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, chatId, text, senderId, receiverId, timestamp, read];
}
