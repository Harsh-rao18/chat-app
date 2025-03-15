import 'dart:io';

import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/feature/addpost/domain/usecase/delete_post_usecse.dart';
import 'package:application_one/feature/addpost/domain/usecase/post_pick_image_use_case.dart';
import 'package:application_one/feature/addpost/domain/usecase/upload_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostPickImageUseCase _pickImageUseCase;
  final UploadPostUsecase _postUsecase;
  final DeletePostUsecse _deletePostUsecse;

  PostBloc({
    required PostPickImageUseCase pickImageUseCase,
    required UploadPostUsecase postUsecase,
    required DeletePostUsecse deletePostUsecse,
  })  : _pickImageUseCase = pickImageUseCase,
        _postUsecase = postUsecase,
        _deletePostUsecse = deletePostUsecse,
        super(PostInitial()) {
    on<PickAndCompressImageEvent>((event, emit) async {
      emit(PostLoading());
      final result = await _pickImageUseCase(NoParams());
      result.fold(
        (failure) => emit(PostError(failure.message)),
        (file) => emit(PostImagePicked(file)),
      );
    });

    on<PostUploadEvent>((event, emit) async {
      emit(PostLoading());
      final result = await _postUsecase(UploadPostUsecaseParams(
          userId: event.userId, content: event.content, file: event.file));

      result.fold(
        (failure) => emit(PostError(failure.message)),
        (file) => emit(PostUploaded()),
      );
    });

    on<PostDeleteEvent>((event, emit) async {
      emit(PostLoading());
      final result = await _deletePostUsecse(DeletePostParams(event.postId));

      result.fold(
        (failure) => emit(PostError(failure.message)),
        (_) => emit(PostDelete()),
      );
    });
  }
}
