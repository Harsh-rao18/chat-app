import 'package:application_one/core/common/entities/user.dart';

class Notification {
  final int id;
  final int postId;
  final String notification;
  final DateTime createdAt;
  final String userId;
  final User? user;

  const Notification({
    required this.id,
    required this.postId,
    required this.notification,
    required this.createdAt,
    required this.userId,
    this.user,
  });
}
