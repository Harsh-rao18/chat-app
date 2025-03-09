import 'package:application_one/feature/followers/domain/entities/followers.dart';
import 'package:application_one/feature/followers/domain/usecase/follow_user_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_follower_count_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_follower_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_following_count_usecase.dart';
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
  final GetFollowerCountUsecase _getFollowerCountUsecase;
  final GetFollowingCountUsecase _getFollowingCountUsecase;

  FollowerBloc({
    required FollowUserUsecase followUserUsecase,
    required UnfollowUserUsecase unfollowUserUsecase,
    required GetFollowerUsecase getFollowerUsecase,
    required GetFollowingUsecase getFollowingUsecase,
    required GetFollowerCountUsecase getFollowerCountUsecase,
    required GetFollowingCountUsecase getFollowingCountUsecase,
  })  : _followUserUsecase = followUserUsecase,
        _unfollowUserUsecase = unfollowUserUsecase,
        _getFollowerUsecase = getFollowerUsecase,
        _getFollowingUsecase = getFollowingUsecase,
        _getFollowerCountUsecase = getFollowerCountUsecase,
        _getFollowingCountUsecase = getFollowingCountUsecase,
        super(FollowerInitial()) {
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnFollowUser);
    on<GetFollowersEvent>(_onGetFollowers);
    on<GetFollowingEvent>(_onGetFollowing);
    on<FetchFollowersCount>(_onGetFollowersCount);
    on<FetchFollowingCount>(_onGetFollowingCount);
  }

  Future<void> _onFollowUser(
      FollowUserEvent event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] FollowUserEvent received for ${event.followerId} -> ${event.followingId}");
    emit(FollowerLoading());
    final result = await _followUserUsecase(
      FollowUserParams(followerId: event.followerId, followingId: event.followingId),
    );

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error following user: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (_) {
        print("✅ [FollowerBloc] Successfully followed user");
        emit(FollowerInitial());
      },
    );
  }

  Future<void> _onUnFollowUser(
      UnfollowUserEvent event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] UnfollowUserEvent received for ${event.followerId} -> ${event.followingId}");
    emit(FollowerLoading());
    final result = await _unfollowUserUsecase(
      UnfollowUserParams(followerId: event.followerId, followingId: event.followingId),
    );

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error unfollowing user: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (_) {
        print("✅ [FollowerBloc] Successfully unfollowed user");
        emit(FollowerInitial());
      },
    );
  }

  Future<void> _onGetFollowers(
      GetFollowersEvent event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] GetFollowersEvent received for userId: ${event.userId}");
    emit(FollowerLoading());
    final result = await _getFollowerUsecase(GetFollowersParams(userId: event.userId));

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error fetching followers: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (followers) {
        print("✅ [FollowerBloc] Fetched ${followers.length} followers");
        emit(FollowerLoaded(followers));
      },
    );
  }

  Future<void> _onGetFollowing(
      GetFollowingEvent event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] GetFollowingEvent received for userId: ${event.userId}");
    emit(FollowerLoading());
    final result = await _getFollowingUsecase(GetFollowingParams(userId: event.userId));

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error fetching following: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (following) {
        print("✅ [FollowerBloc] Fetched ${following.length} following users");
        emit(FollowerFollowingLoaded(following));
      },
    );
  }

  Future<void> _onGetFollowersCount(
      FetchFollowersCount event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] FetchFollowersCount received for userId: ${event.userId}");
    emit(FollowerLoading());
    final result = await _getFollowerCountUsecase(GetFollowerCountParams(event.userId));

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error fetching follower count: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (count) {
        print("✅ [FollowerBloc] Fetched follower count: $count");
        emit(FollowersCountLoaded(count));
      },
    );
  }

  Future<void> _onGetFollowingCount(
      FetchFollowingCount event, Emitter<FollowerState> emit) async {
    print("📌 [FollowerBloc] FetchFollowingCount received for userId: ${event.userId}");
    emit(FollowerLoading());
    final result = await _getFollowingCountUsecase(GetFollowingCountParams(event.userId));

    result.fold(
      (failure) {
        print("❌ [FollowerBloc] Error fetching following count: ${failure.message}");
        emit(FollowerError(failure.message));
      },
      (count) {
        print("✅ [FollowerBloc] Fetched following count: $count");
        emit(FollowingCountLoaded(count));
      },
    );
  }
}
