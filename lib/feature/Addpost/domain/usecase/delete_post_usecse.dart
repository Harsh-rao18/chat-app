import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/addpost/domain/repository/post_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeletePostUsecse implements UseCase<void, DeletePostParams> {
  final PostRepository repository;
  DeletePostUsecse(this.repository);
  @override
  Future<Either<Failure, void>> call(DeletePostParams params) async {
    return await repository.deletePost(params.postId);
  }
}

class DeletePostParams {
  final int postId;
  DeletePostParams(this.postId);
}
