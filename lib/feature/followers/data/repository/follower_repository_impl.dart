import 'package:application_one/core/error/exception.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/followers/data/datasource/follower_remote_data_source.dart';
import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:fpdart/fpdart.dart';

class FollowerRepositoryImpl implements FollowerRepository {
  final FollowerRemoteDataSource remoteDataSource;

  FollowerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> followUser(
      String followerId, String followingId) async {
    try {
      await remoteDataSource.followUser(followerId, followingId);
      return const Right(null); // Fix: No need to return a response
    } on ServerException catch (e) {
      return Left(Failure(e.message)); // Fix: Specific error handling
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(
      String followerId, String followingId) async {
    try {
      await remoteDataSource.unfollowUser(followerId, followingId);
      return const Right(null); // Fix: No need to return a response
    } on ServerException catch (e) {
      return Left(Failure(e.message)); // Fix: Specific error handling
    }
  }

  @override
  Future<Either<Failure, List<Followers>>> getFollowers(String userId) async {
    try {
      final response = await remoteDataSource.getFollowers(userId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message)); // Fix: Specific error handling
    }
  }

  @override
  Future<Either<Failure, List<Followers>>> getFollowing(String userId) async {
    try {
      final response = await remoteDataSource.getFollowing(userId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message)); // Fix: Specific error handling
    }
  }
}
