part of 'follower_bloc.dart';

sealed class FollowerState extends Equatable {
  const FollowerState();

  @override
  List<Object> get props => [];
}

final class FollowerInitial extends FollowerState {}

final class FollowerLoading extends FollowerState {}

final class FollowerLoaded extends FollowerState {
  final List<Followers> followers;
  const FollowerLoaded(this.followers);

  @override
  List<Object> get props => [followers];
}

final class FollowerFollowingLoaded extends FollowerState {
  final List<Followers> following;
  const FollowerFollowingLoaded(this.following);

  @override
  List<Object> get props => [following];
}

final class FollowerError extends FollowerState {
  final String message;
  const FollowerError(this.message);

  @override
  List<Object> get props => [message];
}
