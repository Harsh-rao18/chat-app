import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/notification/data/model/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotication(String userId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient supabaseClient;
  NotificationRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<NotificationModel>> fetchNotication(String userId) async {
    try {
      final response = await supabaseClient
    .from("notifications")
    .select('''
        id, post_id, notification, created_at, user_id, to_user_id,
        user:user_id (id, email, metadata)
    ''')
    .eq("to_user_id", userId) // Fetch notifications for the current user
    .order("id", ascending: false);


    return response.map<NotificationModel>((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
