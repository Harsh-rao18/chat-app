part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}


class SearchUserByName extends MessageEvent {
  final String name;
  const SearchUserByName(this.name);
}
