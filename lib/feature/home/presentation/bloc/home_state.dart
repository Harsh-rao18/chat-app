part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

/// Improved HomeSuccess with a message
final class HomeSuccess extends HomeState {
  final String message; // Now holds a success message
  const HomeSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class HomeLoaded extends HomeState {
  final List<Post> posts;
  const HomeLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
