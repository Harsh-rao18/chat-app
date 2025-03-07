import 'package:application_one/core/common/model/user_model.dart';
import 'package:application_one/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class GetUserRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
}

class GetUserRemoteDataSourceImpl implements GetUserRemoteDataSource {
  final SupabaseClient supabaseClient;
  GetUserRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select('*')
          .eq("id", userId)
          .single();
      final user = UserModel.fromMap(response);
      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
