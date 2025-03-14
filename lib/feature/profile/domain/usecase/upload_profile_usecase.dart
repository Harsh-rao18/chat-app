import 'dart:io';
import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:application_one/core/error/failure.dart';


class UploadProfileUsecase implements UseCase<String, UploadProfileParams> {
  final StorageRepository repository;

  UploadProfileUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileParams params) async {
    return await repository.uploadImageAndUpdateProfile(
      userId: params.userId,
      description: params.description,
      file: params.file,
    );
  }
}

class UploadProfileParams {
  final String userId;
  final String description;
  final File? file;

  UploadProfileParams({
    required this.userId,
    required this.description,
    this.file,
  });
}