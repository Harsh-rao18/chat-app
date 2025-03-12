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
}
