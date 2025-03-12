import 'package:application_one/feature/chat/domain/usecase/get_or_create_chat_room_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetOrCreateChatRoomUsecase _createChatRoomUsecase;
  ChatBloc({
    required GetOrCreateChatRoomUsecase createChatRoomUsecase,
  })  : _createChatRoomUsecase = createChatRoomUsecase,
        super(ChatInitial()) {
    on<GetOrCreateChatRoom>((event, emit) async {
      final result = await _createChatRoomUsecase(ChatRoomParams(user1: event.user1, user2: event.user2));
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chatRoomId) => emit(ChatRoomCreated(chatRoomId)),
      );
    });
  }
}
