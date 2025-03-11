import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/followers/data/model/followers_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class FollowerRemoteDataSource {
  Future<void> followUser(String followerId, String followingId);
  Future<void> unfollowUser(String followerId, String followingId);
  Future<List<FollowersModel>> getFollowers(String userId);
  Future<List<FollowersModel>> getFollowing(String userId);
  Future<int> getFollowersCount(String userId);
  Future<int> getFollowingCount(String userId);
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
    } on PostgrestException catch (e) {
      throw ServerException('Failed to follow user: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error while following user: $e');
    }
  }

  @override
  Future<void> unfollowUser(String followerId, String followingId) async {
    try {
      await supabaseClient.from('followers').delete().match({
        'follower_id': followerId,
        'following_id': followingId,
      });
    } on PostgrestException catch (e) {
      throw ServerException('Failed to unfollow user: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error while unfollowing user: $e');
    }
  }

@override
Future<List<FollowersModel>> getFollowers(String userId) async {
  try {
    final response = await supabaseClient
        .from('followers')
        .select('follower_id, created_at, users!followers_follower_id_fkey(id, metadata)')
        .eq('following_id', userId);

    return response.map((e) {
      final metadata = (e['users'] != null && e['users']['metadata'] != null)
          ? e['users']['metadata']
          : {}; // Ensure metadata is not null

      return FollowersModel(
        id: e['follower_id'] as String? ?? '',  // Handle possible nulls
        followerId: e['follower_id'] as String? ?? '',
        followingId: userId,
        createdAt: e['created_at'] != null
            ? DateTime.tryParse(e['created_at']) ?? DateTime.now()
            : DateTime.now(), // Avoid null parsing errors
        name: metadata['name'] as String? ?? 'Unknown',
        image: metadata['image'] as String? ?? '',
      );
    }).toList();
  } on PostgrestException catch (e) {
    throw ServerException('Failed to fetch followers: ${e.message}');
  } catch (e) {
    throw ServerException('Unexpected error while fetching followers: $e');
  }
}


@override
Future<List<FollowersModel>> getFollowing(String userId) async {
  try {
    final response = await supabaseClient
        .from('followers')
        .select('following_id, created_at, users!followers_following_id_fkey(id, metadata)')
        .eq('follower_id', userId);

    return response.map((e) {
      final metadata = (e['users'] != null && e['users']['metadata'] != null)
          ? e['users']['metadata']
          : {}; // Ensure metadata is not null

      return FollowersModel(
        id: e['following_id'] as String? ?? '',  // Handle possible nulls
        followerId: userId,
        followingId: e['following_id'] as String? ?? '',
        createdAt: e['created_at'] != null
            ? DateTime.tryParse(e['created_at']) ?? DateTime.now()
            : DateTime.now(), // Avoid null parsing errors
        name: metadata['name'] as String? ?? 'Unknown',
        image: metadata['image'] as String? ?? '',
      );
    }).toList();
  } on PostgrestException catch (e) {
    throw ServerException('Failed to fetch following: ${e.message}');
  } catch (e) {
    throw ServerException('Unexpected error while fetching following: $e');
  }
}



@override
Future<int> getFollowersCount(String userId) async {
  try {
    final response = await supabaseClient
        .from('followers')
        .select()
        .filter('following_id', 'eq', userId); // Use 'filter' instead of 'eq'

    return response.length; // Get the count from the list length
  } on PostgrestException catch (e) {
    throw ServerException('Failed to fetch followers count: ${e.message}');
  } catch (e) {
    throw ServerException('Unexpected error while fetching followers count: $e');
  }
}

@override
Future<int> getFollowingCount(String userId) async {
  try {
    final response = await supabaseClient
        .from('followers')
        .select()
        .filter('follower_id', 'eq', userId); // Use 'filter' instead of 'eq'

    return response.length; // Get the count from the list length
  } on PostgrestException catch (e) {
    throw ServerException('Failed to fetch following count: ${e.message}');
  } catch (e) {
    throw ServerException('Unexpected error while fetching following count: $e');
  }
}

}




