import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFollowingCountUsecase
    implements UseCase<int, GetFollowingCountParams> {
  final FollowerRepository repository;
  GetFollowingCountUsecase(this.repository);
  @override
  Future<Either<Failure, int>> call(GetFollowingCountParams params) async {
    return await repository.getFollowingCount(params.userId);
  }
}

class GetFollowingCountParams {
  final String userId;

  GetFollowingCountParams(this.userId);
}
