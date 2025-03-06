import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/messages/data/datasource/message_remote_data_source.dart';
import 'package:application_one/feature/messages/domain/repository/message_repository.dart';
import 'package:fpdart/fpdart.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  MessageRepositoryImpl(this.remoteDataSource);
  
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
