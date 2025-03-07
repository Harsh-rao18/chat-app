import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/showprofile/domain/usecase/get_user_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserUseCase getUserProfile;

  UserProfileBloc(this.getUserProfile) : super(UserProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(UserProfileLoading());
      final result = await getUserProfile(GetUserParams(userId: event.userId));
      result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (user) => emit(UserProfileLoaded(user)),
      );
    });
  }
}

