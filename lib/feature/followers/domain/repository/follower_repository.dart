import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FollowerRepository {
  Future<Either<Failure, void>> followUser(
    String followerId,
    String followingId,
  );

  Future<Either<Failure, void>> unfollowUser(
    String followerId,
    String followingId,
  );

  Future<Either<Failure, List<Followers>>> getFollowers(String userId);
  Future<Either<Failure, List<Followers>>> getFollowing(String userId);
}
