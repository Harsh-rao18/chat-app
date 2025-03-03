import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';

class Post {
  final int? id;
  final String? content;
  final String? image;
  final String? userId;
  final int? likeCount;
  final int? commentCount;
  final DateTime? createdAt;
  final UserModel? user;
  final List<LikeModel>? likes;
  Post({
    this.id,
    this.content,
    this.image,
    this.userId,
    this.likeCount,
    this.commentCount,
    this.createdAt,
    this.user,
    this.likes,
  });
}
