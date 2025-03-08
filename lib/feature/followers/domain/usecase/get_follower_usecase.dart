import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFollowerUsecase
    implements UseCase<List<Followers>, GetFollowersParams> {
  final FollowerRepository repository;
  GetFollowerUsecase(this.repository);
  @override
  Future<Either<Failure, List<Followers>>> call(
      GetFollowersParams params) async {
    return await repository.getFollowers(params.userId);
  }
}

class GetFollowersParams {
  final String userId;
  GetFollowersParams({required this.userId});
}
