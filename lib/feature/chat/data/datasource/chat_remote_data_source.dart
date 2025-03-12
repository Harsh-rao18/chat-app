import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/chat/data/models/chat_room_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class ChatRemoteDataSource {
  Future<String> getOrCreateChatRoom(
      {required String user1, required String user2});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  ChatRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<String> getOrCreateChatRoom(
      {required String user1, required String user2}) async {
    try {
      // Ensure two userId's are always stored in consistent order
      final List<String> users = [user1, user2]..sort();

      final response = await supabaseClient
          .from('chat_rooms')
          .select()
          .eq('user1', users[0])
          .eq('user2', users[1])
          .maybeSingle();
      
      if (response != null) {
        // if chat room already exists
        return response['id'] as String;
      } else {
        // if chat room does not exist
        final newChatRoom = ChatRoomModel(
        id: const Uuid().v4(), // Generate unique chatRoomId
        user1: users[0],
        user2: users[1],
        createdAt: DateTime.now(),
      );

      await supabaseClient.from('chat_rooms').insert(newChatRoom.toMap());

      return newChatRoom.id;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
