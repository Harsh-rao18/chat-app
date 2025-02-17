import 'package:application_one/core/error/exception.dart';
import 'package:application_one/feature/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final res = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (res.user == null) {
        throw ServerException("User not found");
      }
      return UserModel.fromJson(res.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final res = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});
      if (res.user == null) {
        throw ServerException("User not Found");
      }
      throw UserModel.fromJson(res.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
