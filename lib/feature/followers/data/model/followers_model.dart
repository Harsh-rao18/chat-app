import 'package:application_one/feature/followers/domain/entities/followers.dart';

class FollowersModel extends Followers {
  FollowersModel({
    required super.id,
    required super.followerId,
    required super.followingId,
    required super.createdAt,
  });

  // Factory method to convert a Map (Supabase response) to a FollowersModel
  factory FollowersModel.fromMap(Map<String, dynamic> map) {
    return FollowersModel(
      id: map['id'] as String,
      followerId: map['follower_id'] as String, // Updated key
      followingId: map['following_id'] as String, // Updated key
      createdAt: DateTime.parse(map['created_at'] as String), // Updated key
    );
  }

  // Converts a FollowersModel to a Map (for inserting/updating in Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'follower_id': followerId, // Updated key
      'following_id': followingId, // Updated key
      'created_at': createdAt.toIso8601String(), // Updated key
    };
  }
}
