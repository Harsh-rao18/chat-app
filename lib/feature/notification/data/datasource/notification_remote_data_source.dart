import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/notification/data/model/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotification(String userId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient supabaseClient;

  NotificationRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<NotificationModel>> fetchNotification(String userId) async {
    try {
      final response = await supabaseClient
          .from("notifications")
          .select('''
            id, post_id, notification, created_at, user_id, sender_id, seen,
            user:sender_id (id, email, metadata)
          ''')
          .eq("user_id", userId) // Fetch notifications for the recipient
          .order("id", ascending: false);

      return response.map<NotificationModel>((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
