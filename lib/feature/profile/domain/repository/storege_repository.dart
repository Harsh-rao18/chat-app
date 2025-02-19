import 'dart:io';
import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class StorageRepository {
  Future<Either<Failure, File>> pickAndCompressImage();
  Future<Either<Failure, void>> uploadImageAndUpdateProfile({
    required String userId,
    required String description,
    required File file,
  });
}
