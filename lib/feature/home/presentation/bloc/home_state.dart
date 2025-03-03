part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// Initial & Loading States
class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class CommentsLoading extends HomeState {}

class LikesLoading extends HomeState {}

// Success States
class HomeLoaded extends HomeState {
  final List<Post> posts;

  const HomeLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class CommentsLoaded extends HomeState {
  final List<Comment> comments;

  const CommentsLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

class ReplyAddSuccess extends HomeState {
  final String message;

  const ReplyAddSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// ✅ Updated: Track postId for UI updates
class PostLiked extends HomeState {
  final int postId;
  final int likeCount; // ✅ Store the updated like count

  const PostLiked({required this.postId, required this.likeCount});

  @override
  List<Object> get props => [postId, likeCount];
}


// Error States
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentsError extends HomeState {
  final String message;

  const CommentsError(this.message);

  @override
  List<Object> get props => [message];
}

class LikeError extends HomeState {
  final String message;

  const LikeError(this.message);

  @override
  List<Object> get props => [message];
}
