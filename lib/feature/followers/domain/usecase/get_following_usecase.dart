import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFollowingUsecase
    implements UseCase<List<Followers>, GetFollowingParams> {
  final FollowerRepository repository;
  GetFollowingUsecase(this.repository);
  @override
  Future<Either<Failure, List<Followers>>> call(
      GetFollowingParams params) async {
    return await repository.getFollowing(params.userId);
  }
}

class GetFollowingParams {
  final String userId;

  GetFollowingParams({required this.userId});
}
