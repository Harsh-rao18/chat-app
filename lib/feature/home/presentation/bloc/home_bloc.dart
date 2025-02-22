import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/post.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchPostUsecase _fetchPostUsecase;
  HomeBloc({
    required FetchPostUsecase fetchPostUsecase,
  })  : _fetchPostUsecase = fetchPostUsecase,
        super(HomeInitial()) {
    on<HomeFetchPostsEvent>(_onFetchPosts);
  }
  Future<void> _onFetchPosts(
      HomeFetchPostsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final Either<Failure, List<Post>> result =
        await _fetchPostUsecase(NoParams());

    result.fold(
      (failure) => emit(const HomeError("Failed to load posts")),
      (posts) => emit(HomeLoaded(posts)),
    );
  }
}
