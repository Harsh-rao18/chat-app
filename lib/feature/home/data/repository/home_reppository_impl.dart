import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/domain/entities/like.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<Post>>> fetchPosts() async {
    try {
      final posts = await homeRemoteDataSource.fetchPosts();
      return right(posts);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReply({
    required String userId,
    required int postId,
    required String reply,
    required String postUserId, // Added postUserId parameter
  }) async {
    try {
      debugPrint("📝 [HomeRepositoryImpl] Adding reply...");
      debugPrint("➡️ User ID: $userId");
      debugPrint("➡️ Post ID: $postId");
      debugPrint("➡️ Reply: $reply");
      debugPrint("➡️ Post User ID: $postUserId"); // Log postUserId

      await homeRemoteDataSource.addReply(
        userId: userId,
        postId: postId,
        reply: reply,
        postUserId: postUserId, // Pass postUserId to data source
      );

      debugPrint("✅ [HomeRepositoryImpl] Reply added successfully!");
      return right(null);
    } catch (e) {
      debugPrint("❌ [HomeRepositoryImpl] Error adding reply: ${e.toString()}");
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> fetchComments({required int postId}) async {
    try {
      final comments = await homeRemoteDataSource.fetchComments(postId: postId);
      return right(comments);
    } catch (e) {
      return left(Failure(e.toString())); // Return failure message
    }
  }

  @override
  Future<Either<Failure, int>> toggleLike(Like like) async {
    try {
      final likeModel = like is LikeModel
          ? like
          : LikeModel(userId: like.userId, postId: like.postId);
      final updatedLikeCount =
          await homeRemoteDataSource.toggleLike(like: likeModel);
      return right(updatedLikeCount); // Correct type
    } catch (e) {
      return left(Failure(e.toString())); // Proper error handling
    }
  }
}
