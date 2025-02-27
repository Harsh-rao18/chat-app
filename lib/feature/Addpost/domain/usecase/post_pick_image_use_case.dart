import 'dart:io';

import 'package:application_one/core/common/usecase/usecase.dart';
import 'package:application_one/core/error/failure.dart';
import 'package:application_one/feature/Addpost/domain/repository/post_repository.dart';

import 'package:fpdart/fpdart.dart';

class PostPickImageUseCase implements UseCase<File, NoParams> {
  final PostRepository postRepository;
  PostPickImageUseCase(this.postRepository);
  @override
  Future<Either<Failure, File>> call(NoParams params) async {
    return await postRepository.pickAndCompressImage();
  }
}
