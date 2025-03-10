import 'dart:io';

import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/profile/domain/usecase/fetch_profile_post_usecase.dart';

import 'package:application_one/feature/profile/domain/usecase/pick_and_compress_image_usecase.dart';
import 'package:application_one/feature/profile/domain/usecase/upload_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final PickAndCompressImageUseCase _pickAndCompressImageUseCase;
  final UploadProfileUsecase _profileUsecase;
  final FetchProfilePostUsecase _fetchProfilePostUsecase;
  ProfileBloc({
    required PickAndCompressImageUseCase pickAndCompressImageUseCase,
    required UploadProfileUsecase profileUsecase,
    required FetchProfilePostUsecase fetchProfilePostUsecase,
  })  : _pickAndCompressImageUseCase = pickAndCompressImageUseCase,
        _profileUsecase = profileUsecase,
        _fetchProfilePostUsecase = fetchProfilePostUsecase,
        super(ProfileInitial()) {
    on<PickAndCompressImageEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await _pickAndCompressImageUseCase(NoParams());
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (file) => emit(ProfileImagePicked(file)),
      );
    });

    on<ProfileUploadEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await _profileUsecase(
        UploadProfileParams(
          userId: event.userId,
          description: event.description,
          file: event.file,
        ),
      );

      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (imageUrl) =>
            emit(ProfileUploaded(imageUrl)), // Ensure this emits a valid URL
      );
    });

    on<FetchProfilePostsEvent>((event, emit) async {
      emit(ProfileLoading());
       final result = await _fetchProfilePostUsecase(FetchProfilePostParams(event.userId));

    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (posts) => emit(FetchPostLoaded(posts)),
    );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return "Unexpected error.";
  }
}
