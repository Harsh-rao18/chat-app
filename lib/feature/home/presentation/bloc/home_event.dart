part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

// Fetch all posts
class FetchPostsEvent extends HomeEvent {
  const FetchPostsEvent();
}

// Fetch comments for a specific post
class FetchCommentsEvent extends HomeEvent {
  final int postId;

  const FetchCommentsEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}

// Add a reply to a post
class AddReplyEvent extends HomeEvent {
  final String userId;
  final int postId;
  final String postUserId;
  final String reply;

  const AddReplyEvent({
    required this.userId,
    required this.postId,
    required this.postUserId,
    required this.reply,
  });

  @override
  List<Object> get props => [userId, postId, postUserId, reply];
}

// Likes

// Toggle like on a post
class ToggleLikeEvent extends HomeEvent {
  final int postId; // ✅ Explicitly include postId
  final Like like;

  const ToggleLikeEvent({required this.postId, required this.like});

  @override
  List<Object> get props => [postId, like];
}


// Fetch likes for a specific post
class FetchLikesEvent extends HomeEvent {
  final int postId;

  const FetchLikesEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}
