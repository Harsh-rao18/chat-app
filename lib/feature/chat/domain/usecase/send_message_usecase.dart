import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUsecase implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;
  SendMessageUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.message);
  }
}

class SendMessageParams {
  ChatMessage message;
  SendMessageParams(this.message);
}
