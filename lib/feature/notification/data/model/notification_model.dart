import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/feature/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  final UserModel? user;

  NotificationModel({
    required super.id,
    required super.postId,
    required super.notification,
    required super.createdAt,
    required super.userId,
    this.user,
  });

factory NotificationModel.fromMap(Map<String, dynamic> map) {
  return NotificationModel(
    id: map['id'] as int,
    postId: map['post_id'] as int,
    notification: map['notification'] as String,
    createdAt: DateTime.parse(map['created_at']),
    userId: map['user_id'] as String,
    user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'notification': notification,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      if (user != null) 'user': user!.toMap(),
    };
  }
}
