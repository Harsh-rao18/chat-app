import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class CurrentUserUsecase implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUserUsecase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}

