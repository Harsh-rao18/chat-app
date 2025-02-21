part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileImagePicked extends ProfileState {
  final File file;
  ProfileImagePicked(this.file);
}

class ProfileUploaded extends ProfileState {
  final String imageUrl;
  ProfileUploaded(this.imageUrl);
}