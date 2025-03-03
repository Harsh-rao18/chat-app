import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/home/data/models/comment_model.dart';
import 'package:application_one/core/common/model/post_model.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
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

  Future<int> toggleLike({
    required LikeModel like,
  });
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

      return response
          .map<PostModel>((item) => PostModel.fromJson(item))
          .toList();
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
      await supabaseClient.from("comments").insert({
        "post_id": postId,
        "user_id": userId,
        "reply": reply,
      }).then((_) async {
        await supabaseClient.rpc("comment_increment", params: {
          "count": 1,
          "row_id": postId,
        });

        await supabaseClient.from("notifications").insert({
          "user_id": userId,
          "notification": "commented on your post",
          "to_user_id": postUserId,
          "post_id": postId,
        });
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
          .select(
              'id, reply, created_at, user_id, post_id, users(email, metadata)')
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      if (response.isEmpty) return [];

      return response
          .map<CommentModel>((map) => CommentModel.fromMap(map))
          .toList();
    } catch (e) {
      throw ServerException("Failed to fetch comments: ${e.toString()}");
    }
  }

  @override
  Future<int> toggleLike({required LikeModel like}) async {
    try {
      final response = await supabaseClient.rpc(
        'toggle_like',
        params: {
          'p_user_id': like.userId,
          'p_post_id': like.postId,
        },
      );

      if (response == null) {
        throw ServerException("Failed to update like count");
      }

      return response
          as int; // ✅ Ensure Supabase RPC function returns an integer
    } catch (e) {
      throw ServerException("Error toggling like: ${e.toString()}");
    }
  }
}
