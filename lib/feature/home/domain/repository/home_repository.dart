import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/post.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<Post>>> fetchPosts();
}
