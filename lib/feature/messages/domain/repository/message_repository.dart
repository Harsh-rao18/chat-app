import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MessageRepository {

  Future<Either<Failure, List<User>>> searchUsers(String name);
  
}