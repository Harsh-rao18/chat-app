import 'dart:io';

import 'package:application_one/core/error/exception.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class PostRemoteDataSource {
  Future<File?> pickImage();
  Future<File?> compressImage(File file);
  Future<String> uploadImage(String userId, File? file);
  Future<void> uploadPostData(String userId, String content, String file);
  Future<void> deletePost(int postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  PostRemoteDataSourceImpl(this.supabaseClient);

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

  @override
  Future<String> uploadImage(String userId, File? file) async {
    final filename = 'users/$userId/${uuid.v6()}';
    await supabaseClient.storage.from('bucket_h1').upload(filename, file!);

    return supabaseClient.storage.from('bucket_h1').getPublicUrl(filename);
  }

  @override
  Future<void> uploadPostData(
      String userId, String content, String file) async {
    await supabaseClient.from('posts').insert({
      "content": content,
      "user_id": userId,
      "image": file.isNotEmpty ? file : null,
    });
  }

 @override
Future<void> deletePost(int postId) async {
  try {
    final response = await supabaseClient
        .from('posts')
        .delete()
        .eq('id', postId)
        .select(); // Ensure a response is returned

    // Debugging: Print the response
    print("Delete response: $response");

    if (response.isEmpty) {
      throw ServerException("Failed to delete post: Response is null.");
    }

    print("Post deleted successfully");
  } catch (e) {
    print("Error deleting post: $e");
    throw ServerException(e.toString());
  }
}

}
