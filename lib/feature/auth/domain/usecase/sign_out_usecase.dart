import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUsecase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;
  SignOutUsecase(this.authRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}

