import 'dart:io';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/profile/data/datasource/storage_remote_datasource.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';

import 'package:fpdart/fpdart.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageRemoteDataSource remoteDataSource;
  StorageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, File>> pickAndCompressImage() async {
    try {
      final image = await remoteDataSource.pickImage();
      if (image == null) return left(Failure("Image not selected"));

      final compressedImage = await remoteDataSource.compressImage(image);
      if (compressedImage == null) return left(Failure("Image compression failed"));
        
      return right(compressedImage);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImageAndUpdateProfile({
    required String userId,
    required String description,
    File? file,
  }) async {
    try {
      final image = await remoteDataSource.uploadImage(userId, file!);
      final imageUrl =
          await remoteDataSource.updateUserProfile(userId, description, image);
      return right(imageUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> fetchPost() async {
    try {
      final post = await remoteDataSource.fetchPost();
      return right(post);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
