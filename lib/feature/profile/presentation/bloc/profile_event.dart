part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUploadEvent extends ProfileEvent {
  final String userId;
  final String description;
  ProfileUploadEvent(this.userId, this.description);
}
