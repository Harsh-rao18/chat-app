import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddReplyUsecase implements UseCase<void, AddReplyParams> {
  final HomeRepository repository;
  AddReplyUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(AddReplyParams params) async {
    return await repository.addReply(
      userId: params.userId,
      postId: params.postId,
      postUserId: params.postUserId,
      reply: params.reply,
    );
  }
}

class AddReplyParams {
  final String userId;
  final int postId;
  final String postUserId;
  final String reply;

  AddReplyParams({
    required this.userId,
    required this.postId,
    required this.postUserId,
    required this.reply,
  });
}
