import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/search/domain/usecases/search_user_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUserUsecase _searchUserUsecase;
  SearchBloc({required SearchUserUsecase searchUserUsecase})
      : _searchUserUsecase = searchUserUsecase,
        super(SearchInitial()) {
    on<SearchUserByName>(_onSearchUsersByName);
    on<ClearSearchResults>((event, emit) {
      emit(SearchInitial()); // ✅ Reset state to initial
    });
  }

    Future<void> _onSearchUsersByName(
      SearchUserByName event, Emitter<SearchState> emit) async {
    
    print("🔍 Searching for users: ${event.name}"); // Debug log

    emit(SearchLoading());

    final result = await _searchUserUsecase(SearchUserParams(name: event.name));

    result.fold(
    (failure) {
      print("❌ Error: ${failure.message}"); // Debug log
      emit(SearchUserError(failure.message));
    },
    (users) {
      print("✅ Found ${users.length} users"); // Debug log
      emit(SearchUserLoaded(users));
    },
  );
  }

}
