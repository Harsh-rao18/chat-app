part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
   const HomeEvent();
  @override
  List<Object> get props => [];
}


class HomeFetchPostsEvent extends HomeEvent {}

class AddReplyEvent extends HomeEvent {

  final String userId;
  final int postId;
  final String postUserId;
  final String reply;

  const  AddReplyEvent({
    required this.userId,
    required this.postId,
    required this.postUserId,
    required this.reply,
  });

  @override
  List<Object> get props => [userId, postId, postUserId, reply];
}