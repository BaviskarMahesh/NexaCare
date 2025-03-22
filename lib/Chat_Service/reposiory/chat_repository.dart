import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages(String senderId, String receiverId);

  Future<void> sendMessage(MessageEntity message, String receiverId);

  Future<void> markMessagesAsRead(String userId, String attendantId);
}
