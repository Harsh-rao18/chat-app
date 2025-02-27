import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/home/data/models/comment_model.dart';
import 'package:application_one/core/common/model/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<void> addReply({
    required String userId,
    required int postId,
    required String postUserId,
    required String reply,
  });
  Future<List<CommentModel>> fetchComments({required int postId});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await supabaseClient.from('posts').select('''
        id, content, image, created_at, comment_count, like_count, user_id,
        user:user_id(email, metadata)
      ''').order("id", ascending: false);

      if (response.isEmpty) return [];

      return response.map<PostModel>((item) => PostModel.fromJson(item)).toList();
    } catch (e) {
      throw ServerException("Failed to fetch posts: ${e.toString()}");
    }
  }

  @override
  Future<void> addReply({
    required String userId,
    required int postId,
    required String postUserId,
    required String reply,
  }) async {
    try {
      // Increment comment count using RPC
      await supabaseClient.rpc("comment_increment", params: {
        "increment_by": 1, // ✅ Better key naming for RPC function
        "row_id": postId,
      });

      // Insert comment notification
      await supabaseClient.from("notifications").insert({
        "user_id": userId,
        "notification": "commented on your post",
        "to_user_id": postUserId,
        "post_id": postId,
      });

      // Insert the comment
      await supabaseClient.from("comments").insert({
        "post_id": postId,
        "user_id": userId,
        "reply": reply,
      });
    } catch (e) {
      throw ServerException("Failed to add reply: ${e.toString()}");
    }
  }

  @override
  Future<List<CommentModel>> fetchComments({required int postId}) async {
    try {
      final response = await supabaseClient
          .from('comments')
          .select('''
            id, reply, created_at, user_id, post_id,
            users:user_id(email, metadata) 
          ''') // ✅ Use "users" to match Supabase join naming
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      if (response.isEmpty) return [];

      return response.map<CommentModel>((map) => CommentModel.fromMap(map)).toList();
    } catch (e) {
      throw ServerException("Failed to fetch comments: ${e.toString()}");
    }
  }
}
