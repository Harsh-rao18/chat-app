import 'package:application_one/core/common/cubit/app_user_cubit.dart';
import 'package:application_one/core/secret/app_secret.dart';
import 'package:application_one/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:application_one/feature/auth/data/repository/auth_reposotory_impl.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:application_one/feature/auth/domain/usecase/current_user_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_out_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/profile/data/datasource/storage_remote_datasource.dart';
import 'package:application_one/feature/profile/data/repository/storage_repository_impl.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:application_one/feature/profile/domain/usecase/upload_profile_usecase.dart';
import 'package:application_one/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final servicelocator = GetIt.instance;

Future<void> initDependency() async {
  final supabase = await Supabase.initialize(
      url: AppSecret.supabaseUrl, anonKey: AppSecret.supabaseAnonKey);

  servicelocator.registerLazySingleton(() => supabase.client);
  servicelocator.registerLazySingleton(() => AppUserCubit());
  _initAuth();
  _profile();
}

void _initAuth() {
  servicelocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => SignUpUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory(
    () => SignInUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => CurrentUserUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => SignOutUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => AuthBloc(
      signUpUsecase: servicelocator(),
      signInUsecase: servicelocator(),
      currentUserUsecase: servicelocator(),
      appUserCubit: servicelocator(),
      signOutUsecase: servicelocator(),
    ),
  );
}

void _profile() {
  servicelocator.registerFactory<StorageRemoteDataSource>(
    () => StorageRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<StorageRepository>(
    () => StorageRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => UploadProfileUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => ProfileBloc(
      profileUsecase: servicelocator(),
    ),
  );
}
