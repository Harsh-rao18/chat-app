import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class SignInUsecase implements UseCase<User, SignInParams> {
  final AuthRepository authRepository;
  SignInUsecase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
