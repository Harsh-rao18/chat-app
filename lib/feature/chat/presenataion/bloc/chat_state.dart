part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  ChatLoaded(List<ChatMessage> messages) : messages = List.from(messages);

  @override
  List<Object> get props => [messages]; // Ensure UI rebuild
}



final class ChatRoomCreated extends ChatState {
  final String chatRoomId;
  
  const ChatRoomCreated(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}


final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
