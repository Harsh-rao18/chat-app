import 'dart:io';

import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/post/domain/repository/post_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadPostUsecase implements UseCase<void, UploadPostUsecaseParams> {
  final PostRepository postRepository;
  UploadPostUsecase(this.postRepository);
  @override
  Future<Either<Failure, void>> call(UploadPostUsecaseParams params) async {
    return await postRepository.uploadPost(
      userId: params.userId,
      content: params.content,
      file: params.file,
    );
  }
}

class UploadPostUsecaseParams {
  final String userId;
  final String content;
  final File? file;

  UploadPostUsecaseParams({
    required this.userId,
    required this.content,
    required this.file,
  });
}
