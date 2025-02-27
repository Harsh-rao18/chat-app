import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchProfilePostUsecase implements UseCase<List<Post>, NoParams> {
  final StorageRepository repository;
  FetchProfilePostUsecase(this.repository);
  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.fetchPost();
  }
}
