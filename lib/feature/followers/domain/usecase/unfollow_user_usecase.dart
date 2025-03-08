import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class UnfollowUserUsecase implements UseCase<void, UnfollowUserParams> {
  final FollowerRepository repository;
  UnfollowUserUsecase(this.repository);
  @override
  Future<Either<Failure, void>> call(UnfollowUserParams params) async {
    return await repository.unfollowUser(params.followerId, params.followingId);
  }
}

class UnfollowUserParams {
  final String followerId;
  final String followingId;

  UnfollowUserParams({required this.followerId, required this.followingId});
}
