import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/search/data/datasource/search_remote_data_source.dart';
import 'package:application_one/feature/search/domain/repository/search_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  SearchRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, List<User>>> searchUsers(String name) async {
    try {
      final users = await remoteDataSource.searchUser(name);
      return Right(users);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
}
