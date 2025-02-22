import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:application_one/feature/home/domain/entities/post.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class HomeReppositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeReppositoryImpl(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, List<Post>>> fetchPosts() async {
    try {
      final posts = await homeRemoteDataSource.fetchPosts();
      return right(posts);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
