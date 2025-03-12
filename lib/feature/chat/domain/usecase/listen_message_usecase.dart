import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';


class ListenToMessagesUseCase {
  final ChatRepository repository;

  ListenToMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String chatRoomId) {
    return repository.listenToMessages(chatRoomId).map((either) {
      return either.fold(
        (failure) => [],  // Return empty list on failure
        (messages) => messages, // Pass the list of messages
      );
    });
  }
}
