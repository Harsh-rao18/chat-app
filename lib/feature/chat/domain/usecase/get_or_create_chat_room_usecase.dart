import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetOrCreateChatRoomUsecase implements UseCase<String, ChatRoomParams> {
  final ChatRepository repository;
  GetOrCreateChatRoomUsecase(this.repository);
  @override
  Future<Either<Failure, String>> call(ChatRoomParams params) async {
    return await repository.getOrCreateChatRoom(
      user1: params.user1,
      user2: params.user2,
    );
  }
}

class ChatRoomParams {
  final String user1;
  final String user2;

  ChatRoomParams({
    required this.user1,
    required this.user2,
  });
}
