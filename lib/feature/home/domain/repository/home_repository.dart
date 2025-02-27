import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<Post>>> fetchPosts();

  Future<Either<Failure, void>> addReply({
    required String userId,
    required int postId,
    required String postUserId,
    required String reply,
  });

  Future<Either<Failure, List<Comment>>> fetchComments({
    required int postId,
  });
}
