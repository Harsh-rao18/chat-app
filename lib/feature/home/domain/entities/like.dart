import 'package:equatable/equatable.dart';

class Like extends Equatable {
  final String userId;
  final int postId;

  const Like({
    required this.userId,
    required this.postId,
  });

  // Factory constructor to create Like from a Map (useful for database operations)
  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      userId: map['userId'] as String,
      postId: map['postId'] as int,
    );
  }

  // Converts Like object to a Map (useful for sending data to Supabase)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'postId': postId,
    };
  }

  // Creates a copy of Like with optional changes
  Like copyWith({String? userId, int? postId}) {
    return Like(
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
    );
  }

  @override
  List<Object> get props => [userId, postId];
}
