import 'package:application_one/core/error/failure.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {

  Future<Either<Failure,User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure,User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure,User>> currentUser();
  Future<Either<Failure,void>> signOut();
}