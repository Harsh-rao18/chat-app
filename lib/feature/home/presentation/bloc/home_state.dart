part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// Initial & Loading States
class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class CommentsLoading extends HomeState {} // Loading state for comments

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
  final String message; // Success message (or use a boolean flag)

  const ReplyAddSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Error States
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentsError extends HomeState { // New specific error state
  final String message;

  const CommentsError(this.message);

  @override
  List<Object> get props => [message];
}
