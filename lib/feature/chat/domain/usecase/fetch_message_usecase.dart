import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchMessageUsecase
    implements UseCase<List<ChatMessage>, FetchMessageParams> {
  final ChatRepository repository;
  FetchMessageUsecase(this.repository);
  @override
  Future<Either<Failure, List<ChatMessage>>> call(
      FetchMessageParams params) async {
    return await repository.fetchMessages(params.chatRoomId);
  }
}

class FetchMessageParams {
  final String chatRoomId;
  FetchMessageParams({required this.chatRoomId});
}
