import 'dart:io';
import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PostRepository {
  Future<Either<Failure, File>> pickAndCompressImage();

  Future<Either<Failure, void>> uploadPost({
    required String userId,
    required String content,
    File? file,
  });
}
