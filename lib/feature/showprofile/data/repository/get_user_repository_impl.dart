import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/showprofile/data/datasource/get_user_remote_data_source.dart';
import 'package:application_one/feature/showprofile/domain/repositiory/get_user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserRepositoryImpl implements GetUserRepository {
  final GetUserRemoteDataSource remoteDataSource;
  GetUserRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
