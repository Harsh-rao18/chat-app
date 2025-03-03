import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/home/domain/entities/like.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class ToggleLikeUseCase implements UseCase<int, ToggleLikeParams> { // ✅ Return int instead of void
  final HomeRepository repository;

  ToggleLikeUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(ToggleLikeParams params) { // ✅ Return int
    return repository.toggleLike(params.like);
  }
}

class ToggleLikeParams {
  final Like like;

  ToggleLikeParams({required this.like});
}
