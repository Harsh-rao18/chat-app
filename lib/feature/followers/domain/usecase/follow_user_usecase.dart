import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class FollowUserUsecase implements UseCase<void, FollowUserParams> {
  final FollowerRepository repository;
  FollowUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(FollowUserParams params) async {
    return await repository.followUser(params.followerId, params.followingId);
  }
}

class FollowUserParams {
  final String followerId;
  final String followingId;

  FollowUserParams({required this.followerId, required this.followingId});
}
