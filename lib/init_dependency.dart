import 'package:application_one/core/common/cubit/app_user_cubit.dart';
import 'package:application_one/core/secret/app_secret.dart';
import 'package:application_one/feature/addpost/domain/usecase/delete_post_usecse.dart';
import 'package:application_one/feature/addpost/domain/usecase/post_pick_image_use_case.dart';
import 'package:application_one/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:application_one/feature/auth/data/repository/auth_reposotory_impl.dart';
import 'package:application_one/feature/auth/domain/repository/auth_repository.dart';
import 'package:application_one/feature/auth/domain/usecase/current_user_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_out_usecase.dart';
import 'package:application_one/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:application_one/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:application_one/feature/chat/data/datasource/chat_remote_data_source.dart';
import 'package:application_one/feature/chat/data/repository/chat_repository_impl.dart';
import 'package:application_one/feature/chat/domain/repository/chat_repository.dart';
import 'package:application_one/feature/chat/domain/usecase/fetch_message_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/get_or_create_chat_room_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/listen_message_usecase.dart';
import 'package:application_one/feature/chat/domain/usecase/send_message_usecase.dart';
import 'package:application_one/feature/chat/presenataion/bloc/chat_bloc.dart';
import 'package:application_one/feature/followers/data/datasource/follower_remote_data_source.dart';
import 'package:application_one/feature/followers/data/repository/follower_repository_impl.dart';
import 'package:application_one/feature/followers/domain/repository/follower_repository.dart';
import 'package:application_one/feature/followers/domain/usecase/follow_user_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_follower_count_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_follower_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_following_count_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/get_following_usecase.dart';
import 'package:application_one/feature/followers/domain/usecase/unfollow_user_usecase.dart';
import 'package:application_one/feature/followers/presentation/bloc/follower_bloc.dart';
import 'package:application_one/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:application_one/feature/home/data/repository/home_reppository_impl.dart';
import 'package:application_one/feature/home/domain/repository/home_repository.dart';
import 'package:application_one/feature/home/domain/usecase/add_reply_usecase.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_comments.dart';
import 'package:application_one/feature/home/domain/usecase/fetch_post_usecase.dart';
import 'package:application_one/feature/home/domain/usecase/toggle_like_usecase.dart';
import 'package:application_one/feature/home/presentation/bloc/home_bloc.dart';
import 'package:application_one/feature/search/data/datasource/search_remote_data_source.dart';
import 'package:application_one/feature/search/data/repository/search_repository_impl.dart';
import 'package:application_one/feature/search/domain/repository/search_repository.dart';
import 'package:application_one/feature/search/domain/usecases/search_user_usecase.dart';
import 'package:application_one/feature/search/presentation/bloc/search_bloc.dart';
import 'package:application_one/feature/notification/data/datasource/notification_remote_data_source.dart';
import 'package:application_one/feature/notification/data/repository/notification_repository_impl.dart';
import 'package:application_one/feature/notification/domain/repository/notification_repository.dart';
import 'package:application_one/feature/notification/domain/usecase/notification_usecase.dart';
import 'package:application_one/feature/notification/presenation/bloc/notification_bloc.dart';
import 'package:application_one/feature/addpost/data/datasource/post_remote_data_source.dart';
import 'package:application_one/feature/addpost/data/repository/post_repository_impl.dart';
import 'package:application_one/feature/addpost/domain/repository/post_repository.dart';

import 'package:application_one/feature/addpost/domain/usecase/upload_post_usecase.dart';
import 'package:application_one/feature/addpost/presentaion/bloc/post_bloc.dart';
import 'package:application_one/feature/profile/data/datasource/storage_remote_datasource.dart';
import 'package:application_one/feature/profile/data/repository/storage_repository_impl.dart';
import 'package:application_one/feature/profile/domain/repository/storege_repository.dart';
import 'package:application_one/feature/profile/domain/usecase/fetch_profile_post_usecase.dart';
import 'package:application_one/feature/profile/domain/usecase/pick_and_compress_image_usecase.dart';
import 'package:application_one/feature/profile/domain/usecase/upload_profile_usecase.dart';
import 'package:application_one/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:application_one/feature/showprofile/data/datasource/get_user_remote_data_source.dart';
import 'package:application_one/feature/showprofile/data/repository/get_user_repository_impl.dart';
import 'package:application_one/feature/showprofile/domain/repositiory/get_user_repository.dart';
import 'package:application_one/feature/showprofile/domain/usecase/get_user_use_case.dart';
import 'package:application_one/feature/showprofile/presentation/bloc/user_profile_bloc.dart';
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
  _post();
  _fetchPost();
  _fetchNotification();
  _searchUser();
  _getUserProfile();
  _followers();
  _chat();
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
    () => PickAndCompressImageUseCase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => UploadProfileUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => FetchProfilePostUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => ProfileBloc(
        profileUsecase: servicelocator(),
        pickAndCompressImageUseCase: servicelocator(),
        fetchProfilePostUsecase: servicelocator()),
  );
}

void _post() {
  servicelocator.registerFactory<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<PostRepository>(
    () => PostRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(() => PostPickImageUseCase(servicelocator()));
  servicelocator.registerFactory(() => UploadPostUsecase(servicelocator()));
  servicelocator.registerFactory(() => DeletePostUsecse(servicelocator()));

  servicelocator.registerLazySingleton(
    () => PostBloc(
      pickImageUseCase: servicelocator(),
      postUsecase: servicelocator(),
      deletePostUsecse: servicelocator(),
    ),
  );
}

void _fetchPost() {
  servicelocator.registerFactory<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => FetchPostUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory(
    () => AddReplyUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => FetchCommentsUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => ToggleLikeUseCase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => HomeBloc(
      fetchPostUsecase: servicelocator(),
      addReplyUsecase: servicelocator(),
      fetchCommentsUsecase: servicelocator(),
      toggleLikeUseCase: servicelocator(),
    ),
  );
}

void _fetchNotification() {
  servicelocator.registerFactory<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(
      servicelocator(),
    ),
  );

  servicelocator.registerFactory(
    () => NotificationUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => NotificationBloc(
      notificationUsecase: servicelocator(),
    ),
  );
}

void _searchUser() {
  servicelocator.registerFactory<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<SearchRepository>(
    () => SearchRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => SearchUserUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerLazySingleton(
    () => SearchBloc(
      searchUserUsecase: servicelocator(),
    ),
  );
}

void _getUserProfile() {
  servicelocator.registerFactory<GetUserRemoteDataSource>(
    () => GetUserRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<GetUserRepository>(
    () => GetUserRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetUserUseCase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => UserProfileBloc(
      servicelocator(),
    ),
  );
}

void _followers() {
  servicelocator.registerFactory<FollowerRemoteDataSource>(
    () => FollowerRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<FollowerRepository>(
    () => FollowerRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => FollowUserUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => UnfollowUserUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetFollowerUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetFollowingUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetFollowerCountUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetFollowingCountUsecase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => FollowerBloc(
      followUserUsecase: servicelocator(),
      unfollowUserUsecase: servicelocator(),
      getFollowerUsecase: servicelocator(),
      getFollowingUsecase: servicelocator(),
      getFollowerCountUsecase: servicelocator(),
      getFollowingCountUsecase: servicelocator(),
    ),
  );
}

_chat() {
  servicelocator.registerFactory<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory<ChatRepository>(
    () => ChatRepositoryImpl(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => GetOrCreateChatRoomUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => SendMessageUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => FetchMessageUsecase(
      servicelocator(),
    ),
  );
  servicelocator.registerFactory(
    () => ListenToMessagesUseCase(
      servicelocator(),
    ),
  );

  servicelocator.registerLazySingleton(
    () => ChatBloc(
      createChatRoomUsecase: servicelocator(),
      sendMessageUsecase: servicelocator(),
      fetchMessageUsecase: servicelocator(),
      listenToMessagesUseCase: servicelocator(),
    ),
  );
}
