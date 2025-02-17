import 'package:application_one/core/secret/app_secret.dart';
import 'package:application_one/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:application_one/feature/auth/data/repository/auth_reposotory_impl.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final servicelocator = GetIt.instance;

Future<void> initDependency() async {
  final supabase = await Supabase.initialize(
      url: AppSecret.supabaseUrl, anonKey: AppSecret.supabaseAnonKey);

  servicelocator.registerLazySingleton(() => supabase.client);
  _initAuth();
}

void _initAuth() {
  servicelocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory<AuthRepository>(
    () => AuthReposotoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => SignUpUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory(() => SignInUsecase(servicelocator()));

  servicelocator.registerLazySingleton(
    () => AuthBloc(
      signUpUsecase: servicelocator(),
      signInUsecase: servicelocator(),
    ),
  );
}
