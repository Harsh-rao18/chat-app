part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatRoomCreated extends ChatState {
  final String chatRoomId;
  const ChatRoomCreated(this.chatRoomId);
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

}
