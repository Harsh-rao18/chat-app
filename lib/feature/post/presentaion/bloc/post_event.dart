part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PickAndCompressImageEvent extends PostEvent {}

class RemovePickedImageEvent extends PostEvent {}
