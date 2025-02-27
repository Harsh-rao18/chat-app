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
