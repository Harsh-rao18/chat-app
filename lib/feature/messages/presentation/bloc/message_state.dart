part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageLoading extends MessageState {}

class SearchUserLoaded extends MessageState {
  final List<User> users;
  const SearchUserLoaded(this.users);
}

class SearchUserError extends MessageState {
  final String message;
  const SearchUserError(this.message);
}

