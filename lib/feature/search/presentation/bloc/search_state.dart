part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

class SearchUserLoaded extends SearchState {
  final List<User> users;
  const SearchUserLoaded(this.users);
}

class SearchUserError extends SearchState {
  final String message;
  const SearchUserError(this.message);
}

