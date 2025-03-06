import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/messages/domain/usecases/search_user_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SearchUserUsecase _searchUserUsecase;
  MessageBloc({required SearchUserUsecase searchUserUsecase})
      : _searchUserUsecase = searchUserUsecase,
        super(MessageInitial()) {
    on<SearchUserByName>(_onSearchUsersByName);
  }

    Future<void> _onSearchUsersByName(
      SearchUserByName event, Emitter<MessageState> emit) async {
    
    print("🔍 Searching for users: ${event.name}"); // Debug log

    emit(MessageLoading());

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
