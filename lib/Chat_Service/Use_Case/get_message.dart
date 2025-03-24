import 'package:nexacare/Chat_Service/Entity/messageEntity.dart';
import 'package:nexacare/Chat_Service/reposiory/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<MessageEntity>> call(String senderId, String receiverId) {
    return repository.getMessages(senderId, receiverId);
  }
}
