import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';
import 'package:nexacare/Chat_Service/reposiory/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(MessageEntity message, String chatId) {
    return repository.sendMessage(message, chatId);
  }
}
