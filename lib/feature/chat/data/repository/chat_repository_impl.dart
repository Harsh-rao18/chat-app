import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/data/datasource/chat_remote_data_source.dart';
import 'package:application_one/feature/chat/data/models/chat_message_model.dart';
import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> getOrCreateChatRoom({
    required String user1,
    required String user2,
  }) async {
    try {
      final response = await remoteDataSource.getOrCreateChatRoom(
        user1: user1,
        user2: user2,
      );
      return right(response);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> fetchMessages(
      String chatRoomId) async {
    try {
      final response = await remoteDataSource.fetchMessages(chatRoomId);
      final messages = response.map((e) => e.toEntity()).toList();
      return right(messages);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatMessage>>> listenToMessages(
      String chatRoomId) {
    return remoteDataSource
        .listenToMessages(chatRoomId)
        .map(
          (messages) => right<Failure, List<ChatMessage>>(
              messages.map((e) => e.toEntity()).toList()),
        )
        .handleError(
          (e) => left<Failure, List<ChatMessage>>(Failure(e.toString())),
        );
  }

  @override
  Future<Either<Failure, String>> sendMessage(ChatMessage message) async {
    try {
      final chatMessageModel = ChatMessageModel(
        id: message.id,
        chatRoomId: message.chatRoomId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        type: message.type,
        status: message.status,
        timestamp: message.timestamp,
      );
      await remoteDataSource.sendMessage(chatMessageModel);
      return right(message.id);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

// Extension to convert ChatMessageModel to ChatMessage
extension ChatMessageModelX on ChatMessageModel {
  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      status: status,
      timestamp: timestamp,
    );
  }
}
