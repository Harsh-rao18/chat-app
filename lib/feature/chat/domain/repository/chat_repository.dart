import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  
  Future<Either<Failure, String>> getOrCreateChatRoom({
    required String user1,
    required String user2,
  });
}
