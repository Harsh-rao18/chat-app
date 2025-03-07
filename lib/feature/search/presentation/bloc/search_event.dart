part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}


class SearchUserByName extends SearchEvent {
  final String name;
  const SearchUserByName(this.name);
}

class ClearSearchResults extends SearchEvent {}
