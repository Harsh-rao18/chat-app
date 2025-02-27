import 'dart:io';

import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/feature/Addpost/domain/usecase/post_pick_image_use_case.dart';
import 'package:application_one/feature/Addpost/domain/usecase/upload_post_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostPickImageUseCase _pickImageUseCase;
  final UploadPostUsecase _postUsecase;

  PostBloc({
    required PostPickImageUseCase pickImageUseCase,
    required UploadPostUsecase postUsecase,
  })  : _pickImageUseCase = pickImageUseCase,
        _postUsecase = postUsecase,
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
  }
}
