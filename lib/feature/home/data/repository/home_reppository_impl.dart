import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/domain/entities/like.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
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
    required String postUserId,
    required String reply,
  }) async {
    try {
      await homeRemoteDataSource.addReply(
        userId: userId,
        postId: postId,
        postUserId: postUserId,
        reply: reply,
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString())); // ✅ Return failure message
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> fetchComments(
      {required int postId}) async {
    try {
      final comments = await homeRemoteDataSource.fetchComments(postId: postId);
      return right(comments);
    } catch (e) {
      return left(Failure(e.toString())); // ✅ Return failure message
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
      return right(updatedLikeCount); // ✅ Correct type
    } catch (e) {
      return left(Failure(e.toString())); // ✅ Proper error handling
    }
  }
}
