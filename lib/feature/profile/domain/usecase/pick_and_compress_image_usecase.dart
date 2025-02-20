import 'dart:io';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:fpdart/fpdart.dart';

class PickAndCompressImageUseCase implements UseCase<File, NoParams> {
  final StorageRepository repository;
  PickAndCompressImageUseCase(this.repository);

  @override
  Future<Either<Failure, File>> call(NoParams params) {
    return repository.pickAndCompressImage();
  }
}
