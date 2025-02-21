part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostError extends PostState {
  final String message;
  const PostError(this.message);
}

class PostImagePicked extends PostState {
  final File imagefile;
  const PostImagePicked(this.imagefile);
}