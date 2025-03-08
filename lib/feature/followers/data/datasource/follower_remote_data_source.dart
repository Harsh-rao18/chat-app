import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/followers/data/model/followers_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class FollowerRemoteDataSource {
  Future<void> followUser(String followerId, String followingId);
  Future<void> unfollowUser(String followerId, String followingId);
  Future<List<FollowersModel>> getFollowers(String userId);
  Future<List<FollowersModel>> getFollowing(String userId);
}

class FollowerRemoteDataSourceImpl implements FollowerRemoteDataSource {
  final SupabaseClient supabaseClient;

  FollowerRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> followUser(String followerId, String followingId) async {
    try {
      await supabaseClient.from('followers').insert({
        'follower_id': followerId,
        'following_id': followingId,
      });
    } catch (e) {
      throw ServerException('Failed to follow user: $e');
    }
  }

  @override
  Future<void> unfollowUser(String followerId, String followingId) async {
    try {
      await supabaseClient.from('followers').delete().match({
        'follower_id': followerId,
        'following_id': followingId,
      });
    } catch (e) {
      throw ServerException('Failed to unfollow user: $e');
    }
  }

  @override
  Future<List<FollowersModel>> getFollowers(String userId) async {
    try {
      final response = await supabaseClient
          .from('followers')
          .select()
          .eq('following_id', userId);

      return response.map((e) => FollowersModel.fromMap(e)).toList();
    } catch (e) {
      throw ServerException('Failed to get followers: $e');
    }
  }

  @override
  Future<List<FollowersModel>> getFollowing(String userId) async {
    try {
      final response = await supabaseClient
          .from('followers')
          .select()
          .eq('follower_id', userId);

      return response.map((e) => FollowersModel.fromMap(e)).toList();
    } catch (e) {
      throw ServerException('Failed to get following list: $e');
    }
  }
}
