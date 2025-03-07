part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class PickAndCompressImageEvent extends ProfileEvent {}

class ProfileUploadEvent extends ProfileEvent {
  final String userId;
  final String description;
  final File? file;

  ProfileUploadEvent({
    required this.userId,
    required this.description,
    this.file,
  });
}

class FetchProfilePostsEvent extends ProfileEvent {
  final String userId;
   FetchProfilePostsEvent(this.userId);
}