part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends UserProfileEvent {
  final String userId;

  const FetchUserProfile(this.userId);

  @override
  List<Object> get props => [userId];
}
