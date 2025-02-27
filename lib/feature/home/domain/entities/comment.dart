

import 'package:application_one/core/common/model/user_model.dart';

class Comment {
  final int id;
  final String reply;
  final DateTime createdAt;
  final String userId;
  final int postId;
  final UserModel? user; // Include user metadata

  Comment({
    required this.id,
    required this.reply,
    required this.createdAt,
    required this.userId,
    required this.postId,
    this.user, // Nullable user field
  });
}



