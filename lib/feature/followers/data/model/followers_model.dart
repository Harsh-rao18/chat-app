import 'package:application_one/feature/followers/domain/entities/followers.dart';

class FollowersModel extends Followers {
  FollowersModel({
    required super.id,
    required super.followerId,
    required super.followingId,
    required super.createdAt,
    required super.name,
    required super.image,
  });

  factory FollowersModel.fromMap(Map<String, dynamic> map) {
    return FollowersModel(
      id: map['follower_id'] as String? ?? '',  // Ensure correct key
      followerId: map['follower_id'] as String? ?? '',
      followingId: map['following_id'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(), // Avoid null parsing errors
      name: map['metadata']?['name'] as String? ?? 'Unknown',
      image: map['metadata']?['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'follower_id': followerId,  // Ensure consistency with database
      'following_id': followingId,
      'created_at': createdAt.toIso8601String(),  // Use ISO format
      'metadata': {
        'name': name,
        'image': image,
      }
    };
  }

  FollowersModel copyWith({
    String? id,
    String? followerId,
    String? followingId,
    DateTime? createdAt,
    String? name,
    String? image,
  }) {
    return FollowersModel(
      id: id ?? this.id,
      followerId: followerId ?? this.followerId,
      followingId: followingId ?? this.followingId,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
