import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/home/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<PostModel>> fetchPosts();

  Future<void> addReply({
    required String userId,
    required int postId,
    required String postUserId,
    required String reply,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;
  HomeRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<PostModel>> fetchPosts() async {
    final post = await supabaseClient.from('posts').select('''
    id,content,image,created_at,comment_count,like_count,user_id,
    user:user_id(email,metadata)
''').order("id", ascending: false);

    return post.map<PostModel>((item) => PostModel.fromJson(item)).toList();
  }

  @override
  Future<void> addReply(
      {required String userId,
      required int postId,
      required String postUserId,
      required String reply}) async {
    try {
      // increment comment count
      await supabaseClient.rpc("comment_increment", params: {
        "count": 1,
        "row_id": postId,
      });

      // add comment notification
      await supabaseClient.from("notifications").insert({
        "user_id": userId,
        "notification": "commented on your post",
        "to_user_id": postUserId,
        "post_id": postId,
      });

      //Insert comment
      await supabaseClient.from("comments").insert({
        "post_id": postId,
        "user_id": userId,
        "reply": reply,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
