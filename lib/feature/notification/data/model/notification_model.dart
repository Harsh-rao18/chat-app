import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  final UserModel? user;

  NotificationModel({
    required super.id,
    super.postId, // Nullable
    required super.notification,
    required super.createdAt,
    required super.userId,
    required super.seen, // Added seen field
    this.user,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      postId: map['post_id'] as int?, // Nullable
      notification: map['notification'] as String,
      createdAt: DateTime.parse(map['created_at']),
      userId: map['user_id'] as String,
      seen: map['seen'] as bool, // Added seen field
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId, // Nullable
      'notification': notification,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'seen': seen, // Added seen field
      if (user != null) 'user': user!.toMap(),
    };
  }
}
