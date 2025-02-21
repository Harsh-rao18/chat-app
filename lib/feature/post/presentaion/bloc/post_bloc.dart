import 'dart:io';

import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/feature/post/domain/usecase/post_pick_Image_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostPickImageUseCase _pickImageUseCase;
  PostBloc({
    required PostPickImageUseCase pickImageUseCase,
  })  : _pickImageUseCase = pickImageUseCase,
        super(PostInitial()) {
    on<PickAndCompressImageEvent>((event, emit) async {
      emit(PostLoading());
      final result = await _pickImageUseCase(NoParams());
      result.fold(
        (failure) => emit(PostError(failure.message)),
        (file) => emit(PostImagePicked(file)),
      );
    });
  }
}
