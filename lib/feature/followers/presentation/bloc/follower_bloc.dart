import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/domain/usecase/follow_user_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_follower_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_following_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/unfollow_user_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'follower_event.dart';
part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final FollowUserUsecase _followUserUsecase;
  final UnfollowUserUsecase _unfollowUserUsecase;
  final GetFollowerUsecase _getFollowerUsecase;
  final GetFollowingUsecase _getFollowingUsecase;

  FollowerBloc({
    required FollowUserUsecase followUserUsecase,
    required UnfollowUserUsecase unfollowUserUsecase,
    required GetFollowerUsecase getFollowerUsecase,
    required GetFollowingUsecase getFollowingUsecase,
  })  : _followUserUsecase = followUserUsecase,
        _unfollowUserUsecase = unfollowUserUsecase,
        _getFollowerUsecase = getFollowerUsecase,
        _getFollowingUsecase = getFollowingUsecase,
        super(FollowerInitial()) {
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnFollowUser);
    on<GetFollowersEvent>(_onGetFollowers);
    on<GetFollowingEvent>(_onGetFollowing);
  }

  Future<void> _onFollowUser(
      FollowUserEvent event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    final result = await _followUserUsecase(
      FollowUserParams(followerId: event.followerId, followingId: event.followingId),
    );

    result.fold(
      (failure) => emit(FollowerError(failure.message)),
      (_) => emit(FollowerInitial()), // Reset state after following
    );
  }

  Future<void> _onUnFollowUser(
      UnfollowUserEvent event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    final result = await _unfollowUserUsecase(
      UnfollowUserParams(followerId: event.followerId, followingId: event.followingId),
    );

    result.fold(
      (failure) => emit(FollowerError(failure.message)),
      (_) => emit(FollowerInitial()), // Reset state after unfollowing
    );
  }

  Future<void> _onGetFollowers(
      GetFollowersEvent event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    final result = await _getFollowerUsecase(GetFollowersParams(userId: event.userId));

    result.fold(
      (failure) => emit(FollowerError(failure.message)),
      (followers) => emit(FollowerLoaded(followers)),
    );
  }

  Future<void> _onGetFollowing(
      GetFollowingEvent event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    final result = await _getFollowingUsecase(GetFollowingParams(userId: event.userId));

    result.fold(
      (failure) => emit(FollowerError(failure.message)),
      (following) => emit(FollowerFollowingLoaded(following)),
    );
  }
}
