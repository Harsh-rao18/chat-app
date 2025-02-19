part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUploaded extends ProfileState {
  final void success;
  ProfileUploaded(this.success);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
