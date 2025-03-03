import 'package:application_one/feature/home/domain/entities/like.dart';

class LikeModel extends Like {
  const LikeModel({required super.userId, required super.postId});

  /// Convert Firestore/Supabase data to `LikeModel`
  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      userId: map['user_id'] as String, // Matching Supabase column names
      postId: map['post_id'] as int,
    );
  }

  /// Convert `LikeModel` to JSON (for Supabase)
  @override
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'post_id': postId,
    };
  }

  /// Creates a copy of `LikeModel` with optional changes
  @override
  LikeModel copyWith({String? userId, int? postId}) {
    return LikeModel(
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
    );
  }
}
