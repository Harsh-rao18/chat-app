import 'package:application_one/core/error/exception.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:application_one/feature/auth/domain/entities/user.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthReposotoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthReposotoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await authRemoteDataSource.signInWithEmailAndPassword(
          email: email, password: password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailAndPassword(
          name: name, email: email, password: password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
