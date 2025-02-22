part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PickAndCompressImageEvent extends PostEvent {}

class PostUploadEvent extends PostEvent {
  final String userId;
  final String content;
  final File? file;

  const PostUploadEvent({required this.userId, required this.content,  this.file});
}
