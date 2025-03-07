import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SearchRemoteDataSource {
  Future<List<UserModel>> searchUser(String name);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SupabaseClient supabaseClient;
  SearchRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<UserModel>> searchUser(String name) async {
    try {
    print("📡 Fetching users from Supabase...");

    final response = await supabaseClient
        .from('users')
        .select('id, email, metadata, created_at')
        .ilike('metadata->>name', '%$name%');

    print("🔄 Supabase Response: $response");

    final List<UserModel> users = response.map<UserModel>((json) {
      return UserModel.fromMap(json); // Properly parse metadata
    }).toList();

    return users;
  } catch (e) {
    print("❌ Supabase Error: $e");
    throw ServerException(e.toString());
  }
  }
}
