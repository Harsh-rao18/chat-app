import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, String>> getOrCreateChatRoom({
    required String user1,
    required String user2,
  });

  Future<Either<Failure, void>> sendMessage(ChatMessage message);
  
  Future<Either<Failure, List<ChatMessage>>> fetchMessages(String chatRoomId);
  
  Stream<Either<Failure, List<ChatMessage>>> listenToMessages(String chatRoomId);

}
