import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/showprofile/domain/repositiory/get_user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserUseCase implements UseCase<User, GetUserParams> {
  final GetUserRepository repository;
  GetUserUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUserProfile(params.userId);
  }
}

class GetUserParams {
  final String userId;
  GetUserParams({required this.userId});
}
