import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:application_one/feature/home/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    super.id,
    super.content,
    super.image,
    super.userId,
    super.likeCount,
    super.commentCount,
    super.createdAt,
    super.user,
    super.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      commentCount: json['comment_count'],
      userId: json['user_id'],
      likeCount: json['like_count'],
      image: json['image'],
      createdAt: json['created_at'],
      user: json['user'] != null ? UserModel.fromMap(json['user']) : null,
      likes: json['likes'] != null
          ? (json['likes'] as List).map((v) => LikeModel.fromJson(v)).toList()
          : null,
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
      'created_at': createdAt,
      'user': user?.toMap(),
      'likes': likes?.map((v) => v.toJson()).toList(),
    };
  }
}
