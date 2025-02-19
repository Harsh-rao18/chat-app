import 'package:application_one/feature/profile/domain/usecase/upload_profile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UploadProfileUsecase _profileUsecase;
  ProfileBloc({
    required UploadProfileUsecase profileUsecase,
  })  : _profileUsecase = profileUsecase,
        super(ProfileInitial()) {
    on<ProfileUploadEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await _profileUsecase(UploadProfileParams(userId: event.userId, description: event.description, file: event.));
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (success) => emit(ProfileUploaded(success)),
      );
    });
  }
}
