import 'package:application_one/feature/chat/domain/entities/chat_message.dart';
import 'package:application_one/feature/chat/domain/usecase/fetch_message_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/get_or_create_chat_room_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/listen_message_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/send_message_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetOrCreateChatRoomUsecase _createChatRoomUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final FetchMessageUsecase _fetchMessageUsecase;
  final ListenToMessagesUseCase _listenToMessagesUseCase;

  ChatBloc({
    required GetOrCreateChatRoomUsecase createChatRoomUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required FetchMessageUsecase fetchMessageUsecase,
    required ListenToMessagesUseCase listenToMessagesUseCase,
  })  : _createChatRoomUsecase = createChatRoomUsecase,
        _sendMessageUsecase = sendMessageUsecase,
        _fetchMessageUsecase = fetchMessageUsecase,
        _listenToMessagesUseCase = listenToMessagesUseCase,
        super(ChatInitial()) {
    // Handle GetOrCreateChatRoom
    on<GetOrCreateChatRoom>((event, emit) async {
      final result = await _createChatRoomUsecase(
        ChatRoomParams(user1: event.user1, user2: event.user2),
      );
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chatRoomId) => emit(ChatRoomCreated(chatRoomId)),
      );
    });

    // Handle Fetch Messages
    on<LoadMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      final result = await _fetchMessageUsecase(
        FetchMessageParams(chatRoomId: event.chatRoomId),
      );

      result.fold(
        (failure) {
          print("❌ Failed to fetch messages: ${failure.message}");
          emit(ChatError(failure.message));
        },
        (messages) {
          print("✅ Fetched ${messages.length} past messages.");
          emit(ChatLoaded(messages));
        },
      );
    });

    // Handle Send Message
    on<SendMessageEvent>((event, emit) async {
      final result =
          await _sendMessageUsecase(SendMessageParams(event.message));
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) => {}, // No explicit success state needed unless required
      );
    });

    // Handle Real-time Message Listening
    on<StartListeningEvent>((event, emit) async {
      await emit.onEach<List<ChatMessage>>(
        _listenToMessagesUseCase(event.chatRoomId),
        onData: (messages) {
          print("🟢 New messages received: ${messages.length}");
          emit(ChatLoaded(List.from(messages)));
        },
        onError: (error, stackTrace) {
          print("❌ Error listening to messages: $error");
          emit(ChatError("Failed to listen to messages"));
        },
      );
    });
  }
}
