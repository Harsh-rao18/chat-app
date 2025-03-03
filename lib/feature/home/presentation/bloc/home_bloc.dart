import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/common/model/post_model.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:application_one/feature/home/domain/entities/comment.dart';
import 'package:application_one/feature/home/domain/entities/like.dart';
import 'package:application_one/feature/home/domain/usecase/add_reply_usecase.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_comments.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_post_usecase.dart';
import 'package:application_one/feature/home/domain/usecase/toggle_like_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchPostUsecase _fetchPostUsecase;
  final AddReplyUsecase _addReplyUsecase;
  final FetchCommentsUsecase _fetchCommentsUsecase;
  final ToggleLikeUseCase _toggleLikeUseCase;

  HomeBloc({
    required FetchPostUsecase fetchPostUsecase,
    required AddReplyUsecase addReplyUsecase,
    required FetchCommentsUsecase fetchCommentsUsecase,
    required ToggleLikeUseCase toggleLikeUseCase,
  })  : _fetchPostUsecase = fetchPostUsecase,
        _addReplyUsecase = addReplyUsecase,
        _fetchCommentsUsecase = fetchCommentsUsecase,
        _toggleLikeUseCase = toggleLikeUseCase,
        super(HomeInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddReplyEvent>(_onAddReply);
    on<FetchCommentsEvent>(_onFetchComments);
    on<ToggleLikeEvent>(_onToggleLike);
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event, Emitter<HomeState> emit) async {
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
        add(FetchCommentsEvent(postId: event.postId));
      },
    );
  }

  Future<void> _onFetchComments(
      FetchCommentsEvent event, Emitter<HomeState> emit) async {
    emit(CommentsLoading());

    final result =
        await _fetchCommentsUsecase(CommentParams(postId: event.postId));

    result.fold(
      (failure) => emit(CommentsError(_mapFailureToMessage(failure))),
      (comments) => emit(CommentsLoaded(comments)),
    );
  }

Future<void> _onToggleLike(ToggleLikeEvent event, Emitter<HomeState> emit) async {
  final currentState = state;
  if (currentState is! HomeLoaded) return;

  emit(LikesLoading()); // ✅ Emit a loading state if needed

  final result = await _toggleLikeUseCase(ToggleLikeParams(like: event.like));

  result.fold(
    (failure) => emit(LikeError(failure.toString())), // ✅ Emit error if failed
    (_) {
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.like.postId) {
          final isLiked = post.likes?.any((like) => like.userId == event.like.userId) ?? false;

          List<Like> updatedLikes;
          if (isLiked) {
            updatedLikes = post.likes!.where((like) => like.userId != event.like.userId).toList();
          } else {
            updatedLikes = [...post.likes ?? [], event.like];
          }

          if (post is PostModel) {
            return post.copyWith(
              likes: updatedLikes.map((like) => LikeModel(userId: like.userId, postId: like.postId)).toList(),
              likeCount: updatedLikes.length,
            );
          }
        }
        return post;
      }).toList();

      emit(HomeLoaded(updatedPosts)); // ✅ Ensure state is updated properly
    },
  );
}


  String _mapFailureToMessage(Failure failure) {
    return "Unexpected error.";
  }
}
