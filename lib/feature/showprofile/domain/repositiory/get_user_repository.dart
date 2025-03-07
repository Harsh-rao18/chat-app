import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetUserRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
}
