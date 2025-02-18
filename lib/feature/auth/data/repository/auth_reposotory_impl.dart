import 'package:application_one/core/error/exception.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User not logged in"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final user = await authRemoteDataSource.signOutCurrentUser();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Unexpected error: ${e.toString()}"));
    }
  }
}
