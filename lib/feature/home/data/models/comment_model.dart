import 'package:application_one/core/common/model/user_model.dart';
import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.reply,
    required super.createdAt,
    required super.userId,
    required super.postId,
    super.user, // ✅ Marked as nullable
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? 0,
      reply: map['reply'] ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      userId: map['user_id'] ?? '',
      postId: map['post_id'] ?? 0,
      user: (map['users'] != null && map['users'] is Map<String, dynamic>) 
          ? UserModel.fromMap(map['users']) 
          : null, // ✅ Added explicit null check
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reply': reply,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'post_id': postId,
      'users': user?.toMap(), // ✅ Correct Supabase join key
    };
  }
}
