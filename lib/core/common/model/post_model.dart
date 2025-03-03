import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:application_one/core/common/entities/post.dart';

class PostModel extends Post {
  PostModel({
    super.id,
    super.content,
    super.image,
    super.userId,
    super.likeCount,
    super.commentCount,
    super.createdAt, // ✅ Ensure DateTime? type
    super.user,
    super.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      content: json['content'] as String? ?? '',
      commentCount: json['comment_count'] as int? ?? 0,
      userId: json['user_id'] as String,
      likeCount: json['like_count'] as int? ?? 0,
      image: json['image'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null, // ✅ Fixed
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      likes: json['likes'] != null
          ? (json['likes'] as List<dynamic>).map((v) => LikeModel.fromMap(v)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'like_count': likeCount,
      'comment_count': commentCount,
      'user_id': userId,
      'image': image,
      'created_at': createdAt?.toIso8601String(), // ✅ Convert DateTime to String
      'user': user?.toMap(),
      'likes': likes?.map((v) => v.toMap()).toList(),
    };
  }

  // ✅ Fixed copyWith method
  PostModel copyWith({
    int? id,
    String? content,
    String? image,
    String? userId,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt, // ✅ Ensure DateTime? type
    UserModel? user,
    List<LikeModel>? likes,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt, // ✅ Now properly typed
      user: user ?? this.user,
      likes: likes ?? this.likes,
    );
  }
}
