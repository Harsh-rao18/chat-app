import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchProfilePostUsecase implements UseCase<List<Post>, FetchProfilePostParams> {
  final StorageRepository repository;
  FetchProfilePostUsecase(this.repository);
  
  @override
  Future<Either<Failure, List<Post>>> call(FetchProfilePostParams params) async{
    return await repository.fetchPost(params.userId);
  }
  
}

class FetchProfilePostParams {
  final String userId;
  FetchProfilePostParams(this.userId);
  
}