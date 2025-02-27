import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/domain/usecase/add_reply_usecase.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_comments.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchPostUsecase _fetchPostUsecase;
  final AddReplyUsecase _addReplyUsecase;
  final FetchCommentsUsecase _fetchCommentsUsecase;

  HomeBloc({
    required FetchPostUsecase fetchPostUsecase,
    required AddReplyUsecase addReplyUsecase,
    required FetchCommentsUsecase fetchCommentsUsecase,
  })  : _fetchPostUsecase = fetchPostUsecase,
        _addReplyUsecase = addReplyUsecase,
        _fetchCommentsUsecase = fetchCommentsUsecase,
        super(HomeInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddReplyEvent>(_onAddReply);
    on<FetchCommentsEvent>(_onFetchComments); // 🔄 Renamed for consistency
  }

  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final result = await _fetchPostUsecase(NoParams());

    result.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (posts) => emit(HomeLoaded(posts)),
    );
  }

  Future<void> _onAddReply(AddReplyEvent event, Emitter<HomeState> emit) async {
    final response = await _addReplyUsecase(
      AddReplyParams(
        userId: event.userId,
        postId: event.postId,
        postUserId: event.postUserId,
        reply: event.reply,
      ),
    );

    response.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (_) {
        emit(const ReplyAddSuccess("Reply added successfully"));
        add(FetchCommentsEvent(postId: event.postId)); // 🔄 Updated event name
      },
    );
  }

  Future<void> _onFetchComments(FetchCommentsEvent event, Emitter<HomeState> emit) async {
    final currentState = state;

    if (currentState is! CommentsLoaded) {
      emit(CommentsLoading());
    }

    final result = await _fetchCommentsUsecase(CommentParams(postId: event.postId));

    result.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (comments) => emit(CommentsLoaded(comments)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return "Unexpected error.";
  }
}
