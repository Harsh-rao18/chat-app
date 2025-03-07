import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/search/domain/repository/search_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchUserUsecase implements UseCase<List<User>, SearchUserParams> {
  final SearchRepository repository;
  SearchUserUsecase(this.repository);
  @override
  Future<Either<Failure, List<User>>> call(SearchUserParams params) async {
    print("🔎 UseCase Called with Query: ${params.name}"); 
    return await repository.searchUsers(params.name);
  }
}

class SearchUserParams {
  final String name;
  SearchUserParams({required this.name});
}
