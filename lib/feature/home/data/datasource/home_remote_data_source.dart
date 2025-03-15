import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/home/data/models/comment_model.dart';
import 'package:application_one/core/common/model/post_model.dart';
import 'package:application_one/feature/home/data/models/like_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<void> addReply({
    required String userId,
    required int postId,
    required String reply,
    required String postUserId, // Added postUserId for the notification
  });
  Future<List<CommentModel>> fetchComments({required int postId});
  Future<int> toggleLike({required LikeModel like});
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
    required String reply,
    required String postUserId, // Added postUserId parameter
  }) async {
    try {
      debugPrint("📡 [HomeRemoteDataSource] Adding reply for post $postId...");
      debugPrint("➡️ User ID: $userId, Reply: $reply");

      // Insert the reply into the comments table
      await supabaseClient.from("comments").insert({
        "post_id": postId,
        "user_id": userId,
        "reply": reply,
      }).then((_) async {
        debugPrint("✅ [HomeRemoteDataSource] Reply added to comments table");

        // Increment the comment count for the post
        await supabaseClient.rpc("comment_increment", params: {
          "count": 1,
          "row_id": postId,
        });

        debugPrint(
            "✅ [HomeRemoteDataSource] Incremented comment count for post $postId");

        // Insert notification to the notifications table
        await supabaseClient.from("notifications").insert({
          "user_id": postUserId, // The user who owns the post
          "sender_id": userId, // The user who is commenting
          "notification": "commented on your post",
          "post_id": postId,
        });

        debugPrint(
            "✅ [HomeRemoteDataSource] Notification sent for post $postId");
      });
    } catch (e) {
      debugPrint(
          "❌ [HomeRemoteDataSource] Error adding reply: ${e.toString()}");
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
      debugPrint(
          "❌ [HomeRemoteDataSource] Error fetching comments: ${e.toString()}");
      throw ServerException("Failed to fetch comments: ${e.toString()}");
    }
  }

  @override
  Future<int> toggleLike({required LikeModel like}) async {
    try {
      final response = await supabaseClient.rpc(
        'toggle_like',
        params: {
          'p_post_id': like.postId, // ✅ Match SQL parameter
          'p_user_id': like.userId, // ✅ Match SQL parameter
        },
      );

      if (response == null) {
        throw ServerException("Failed to update like count");
      }

      return response as int; // Ensure Supabase RPC function returns an integer
    } catch (e) {
      debugPrint(
          "❌ [HomeRemoteDataSource] Error toggling like: ${e.toString()}");
      throw ServerException("Error toggling like: ${e.toString()}");
    }
  }
}
