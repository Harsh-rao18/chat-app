import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFollowerCountUsecase implements UseCase<int,GetFollowerCountParams> {
  final FollowerRepository repository;
  GetFollowerCountUsecase(this.repository);
  @override
  Future<Either<Failure, int>> call(GetFollowerCountParams params) async {
    return await repository.getFollowersCount(params.userId);
  }
  
}

class GetFollowerCountParams {
  final String userId;

  GetFollowerCountParams(this.userId);
}