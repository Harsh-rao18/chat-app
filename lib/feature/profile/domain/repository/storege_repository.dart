import 'dart:io';
import 'package:application_one/core/common/entities/post.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class StorageRepository {
  /// Picks an image from the gallery and compresses it.
  Future<Either<Failure, File>> pickAndCompressImage();

  /// Uploads an image to Supabase and updates the user profile.
  Future<Either<Failure, String>> uploadImageAndUpdateProfile({
    required String userId,
    required String description,
    File? file,
  });

  /// fetch posts
  Future<Either<Failure, List<Post>>> fetchPost(String userId);
}
