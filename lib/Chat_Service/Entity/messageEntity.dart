import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? id;
  final String chatId; // Added chatId
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

  @override
  List<Object?> get props => [id, chatId, text, senderId, receiverId, timestamp, read];
}
