import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';

abstract class ChatRepository {
  
  Stream<List<MessageEntity>> getMessages(String chatId);

  
  Future<void> sendMessage(MessageEntity message, String chatId);

  Future<void> markMessagesAsRead(String chatId, String userId);
}
