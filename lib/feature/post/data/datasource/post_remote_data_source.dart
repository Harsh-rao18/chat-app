import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

abstract interface class PostRemoteDataSource {
  Future<File?> pickImage();
  Future<File?> compressImage(File file);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {


  final ImagePicker _picker = ImagePicker();
  final uuid = const Uuid();

  @override
  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  @override
  Future<File?> compressImage(File file) async {
    final dir = Directory.systemTemp;
    final targetPath = '${dir.path}/${uuid.v4()}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    return result != null ? File(result.path) : null;
  }
  
}