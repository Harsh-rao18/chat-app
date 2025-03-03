import 'dart:io';
import 'package:application_one/core/common/model/post_model.dart';
import 'package:application_one/core/error/exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class StorageRemoteDataSource {
  Future<File?> pickImage();
  Future<File?> compressImage(File file);
  Future<String> uploadImage(String userId, File? file);
  Future<String> updateUserProfile(
      String userId, String description, String? imageUrl);
  Future<List<PostModel>> fetchPost();
}

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final SupabaseClient supabaseClient;
  StorageRemoteDataSourceImpl(this.supabaseClient);

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
    final filename = 'users/$userId/profile.jpg';
    await supabaseClient.storage
        .from('bucket_h1')
        .upload(filename, file!, fileOptions: const FileOptions(upsert: true));

    return supabaseClient.storage.from('bucket_h1').getPublicUrl(filename);
  }

  @override
  Future<String> updateUserProfile(
      String userId, String description, String? imageUrl) async {
    await supabaseClient.auth.updateUser(UserAttributes(data: {
      "description": description,
      "image": imageUrl ?? "",
    }));

    return imageUrl ?? ""; // ✅ Ensure a String is always returned
  }

@override
Future<List<PostModel>> fetchPost() async {
  try {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw ServerException("User not authenticated");

    final response = await supabaseClient
        .from('posts')
        .select('''
          id, content, image, created_at, comment_count, like_count, user_id,
          user:user_id(email, metadata)
        ''')
        .eq('user_id', user.id) // ✅ Fetch posts only for the authenticated user
        .order("id", ascending: false);

    if (response.isEmpty) return [];

    return response.map<PostModel>((item) => PostModel.fromJson(item)).toList();
  } catch (e) {
    throw ServerException("Failed to fetch user posts: ${e.toString()}");
  }
}

}
