import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';


class FetchPostUsecase implements UseCase<List<Post>, NoParams> {
  final HomeRepository homeRepository;
  FetchPostUsecase(this.homeRepository);
  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await homeRepository.fetchPosts();
  }
}
