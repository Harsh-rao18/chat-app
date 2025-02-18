import 'package:application_one/core/common/cubit/app_user_cubit.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/current_user_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_out_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;
  final CurrentUserUsecase _currentUserUsecase;
  final AppUserCubit _appUserCubit;
  final SignOutUsecase _signOutUsecase;
  AuthBloc({
    required SignUpUsecase signUpUsecase,
    required SignInUsecase signInUsecase,
    required CurrentUserUsecase currentUserUsecase,
    required AppUserCubit appUserCubit,
    required SignOutUsecase signOutUsecase,
  })  : _signUpUsecase = signUpUsecase,
        _signInUsecase = signInUsecase,
        _currentUserUsecase = currentUserUsecase,
        _appUserCubit = appUserCubit,
        _signOutUsecase = signOutUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthUserLoggedIn>(_onUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signUpUsecase(SignUpParams(
        name: event.name, email: event.email, password: event.password));

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signInUsecase(
        SignInParams(email: event.email, password: event.password));

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onUserLoggedIn(AuthUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUserUsecase(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    final response = await _signOutUsecase(NoParams());

    response.fold(
        (l) => emit(AuthFailure(l.message)), (r) => emit(AuthUnauthenticated()));
  } 

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

}
