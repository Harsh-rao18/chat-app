import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/auth/domain/entities/user.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUsecase implements UseCase<User, SignUpParams> {
  final AuthRepository authRepository;
  SignUpUsecase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams(
      {required this.name, required this.email, required this.password});
}
