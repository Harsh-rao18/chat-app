import 'package:application_one/feature/home/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;
  HomeRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<PostModel>> fetchPosts() async {
    final post = await supabaseClient.from('posts').select('''
    id,content,image,created_at,comment_count,like_count,user_id,
    user:user_id(email,metadata)
''').order("id",ascending: false);

  return post.map<PostModel>((item) => PostModel.fromJson(item)).toList();

  }
}
