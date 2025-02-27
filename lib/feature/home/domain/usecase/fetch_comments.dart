import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchCommentsUsecase implements UseCase<List<Comment>, CommentParams> {
  final HomeRepository repository;
  FetchCommentsUsecase(this.repository);
  @override
  Future<Either<Failure, List<Comment>>> call(CommentParams params) async {
    return await repository.fetchComments(postId: params.postId);
  }
}

class CommentParams {
  final int postId;
  const CommentParams({required this.postId});
}
