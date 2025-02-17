import 'package:application_one/feature/auth/domain/entities/user.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;
  AuthBloc({
    required SignUpUsecase signUpUsecase,
    required SignInUsecase signInUsecase,
  })  : _signUpUsecase = signUpUsecase,
        _signInUsecase = signInUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signUpUsecase(SignUpParams(
        name: event.name, email: event.email, password: event.password));

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
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
      (r) => emit(AuthSuccess(r)),
    );
  }
}
