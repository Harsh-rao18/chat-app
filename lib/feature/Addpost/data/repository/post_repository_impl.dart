import 'dart:io';

import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/addpost/data/datasource/post_remote_data_source.dart';
import 'package:application_one/feature/addpost/domain/repository/post_repository.dart';
import 'package:fpdart/fpdart.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  PostRepositoryImpl(this.postRemoteDataSource);
  @override
  Future<Either<Failure, File>> pickAndCompressImage() async {
    try {
      final image = await postRemoteDataSource.pickImage();
      if (image == null) return left(Failure("Image not selected"));

      final compressedImage = await postRemoteDataSource.compressImage(image);
      if (compressedImage == null) {
        return left(Failure("Image compression failed"));
      }

      return right(compressedImage);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadPost(
      {required String userId, required String content, File? file}) async {
    try {
      final image = await postRemoteDataSource.uploadImage(userId, file);
      final post =
          await postRemoteDataSource.uploadPostData(userId, content, image);
      return right(post);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int postId) async {
    try {
      await postRemoteDataSource.deletePost(postId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
