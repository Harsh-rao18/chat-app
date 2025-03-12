part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetOrCreateChatRoom extends ChatEvent {
  final String user1;
  final String user2;

  const GetOrCreateChatRoom(this.user1, this.user2);

  @override
  List<Object> get props => [user1, user2];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatRoomId;

  const LoadMessagesEvent(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}

class SendMessageEvent extends ChatEvent {
  final ChatMessage message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class StartListeningEvent extends ChatEvent {
  final String chatRoomId;

  const StartListeningEvent(this.chatRoomId);

  @override
  List<Object> get props => [chatRoomId];
}
