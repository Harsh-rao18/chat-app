part of 'follower_bloc.dart';

sealed class FollowerEvent extends Equatable {
  const FollowerEvent();

  @override
  List<Object> get props => [];
}

class FollowUserEvent extends FollowerEvent {
  final String followerId;
  final String followingId;

  const FollowUserEvent(this.followerId, this.followingId);

  @override
  List<Object> get props => [followerId, followingId];
}

class UnfollowUserEvent extends FollowerEvent { // Fixed naming
  final String followerId;
  final String followingId;

  const UnfollowUserEvent(this.followerId, this.followingId);

  @override
  List<Object> get props => [followerId, followingId];
}

class GetFollowersEvent extends FollowerEvent {
  final String userId;
  
  const GetFollowersEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetFollowingEvent extends FollowerEvent {
  final String userId;
  
  const GetFollowingEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
