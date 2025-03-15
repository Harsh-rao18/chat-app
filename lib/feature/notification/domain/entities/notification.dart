import 'package:application_one/core/common/entities/user.dart';

class Notification {
  final int id;
  final int? postId; // Nullable since post_id in Supabase can be null
  final String notification;
  final DateTime createdAt;
  final String userId;
  final bool seen; // Added seen field
  final User? user;

  const Notification({
    required this.id,
    this.postId,
    required this.notification,
    required this.createdAt,
    required this.userId,
    required this.seen, // Ensure this is required
    this.user,
  });
}
