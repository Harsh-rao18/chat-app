import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/chat/data/datasource/chat_remote_data_source.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, String>> getOrCreateChatRoom(
      {required String user1, required String user2}) async {
    try {
      final response = await remoteDataSource.getOrCreateChatRoom(
        user1: user1,
        user2: user2,
      );
      return right(response);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
