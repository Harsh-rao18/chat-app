import 'package:application_one/core/common/entities/user.dart';
import 'package:application_one/core/error/exception.dart';
import 'package:application_one/core/common/model/user_model.dart';
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

  Session? get currentUserSession;

  Future<UserModel?> getCurrentUserData();

  Future<void> signOutCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (res.user == null) {
        throw ServerException("User not found");
      }

      return UserModel(
        id: res.user!.id,
        email: res.user!.email ?? '',
        metadata: Metadata.fromMap(res.user!.userMetadata ?? {}),
        createdAt: res.user!.createdAt, // No need for toIso8601String()
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name}, // Store additional metadata
      );

      if (res.user == null) {
        throw ServerException("User not found");
      }

      return UserModel(
        id: res.user!.id,
        email: res.user!.email ?? '',
        metadata: Metadata.fromMap(res.user!.userMetadata ?? {}),
        createdAt: res.user!.createdAt,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select()
            .eq('id', currentUserSession!.user.id)
            .maybeSingle();

        if (userData == null) return null;

        return UserModel.fromMap(userData).copyWith(
          email: currentUserSession!.user.email,
          metadata: Metadata.fromMap(userData['metadata'] ?? {}),
          createdAt: currentUserSession!.user.createdAt, // Directly using the string
        );
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOutCurrentUser() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
