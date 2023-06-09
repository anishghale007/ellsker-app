import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internship_practice/core/network/network_info.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';
import 'package:internship_practice/features/auth/domain/usecases/facebook_login_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/set_user_status_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:internship_practice/features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/features/auth/presentation/cubit/user%20status/user_status_cubit.dart';
import 'package:internship_practice/features/call/data/datasources/call_remote_data_source.dart';
import 'package:internship_practice/features/call/data/repositories/call_repository_impl.dart';
import 'package:internship_practice/features/call/domain/repositories/call_repository.dart';
import 'package:internship_practice/features/call/domain/usecases/get_call_logs_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/call/presentation/bloc/token/token_bloc.dart';
import 'package:internship_practice/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:internship_practice/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/edit_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_chat_message.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_shared_photos_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_shared_videos_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_users_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/seen_message_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/unsend_message_usecase.dart';
import 'package:internship_practice/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:internship_practice/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:internship_practice/features/notification/domain/repositories/notification_repository.dart';
import 'package:internship_practice/features/notification/domain/usecases/send_notification_usecase.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list/user_list_cubit.dart';
import 'package:internship_practice/features/notification/presentation/bloc/notification/notification_bloc.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:internship_practice/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:internship_practice/features/profile/domain/repositories/profile_repository.dart';
import 'package:internship_practice/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:internship_practice/features/profile/domain/usecases/get_current_user_usecase.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  /// BLoC
  ///
  // auth bloc
  sl.registerFactory<GoogleSignInBloc>(
    () => GoogleSignInBloc(gooogleLoginUseCase: sl()),
  );

  sl.registerFactory<FacebookSignInBloc>(
    () => FacebookSignInBloc(facebookLoginUseCase: sl()),
  );

  sl.registerFactory<SignOutCubit>(
    () => SignOutCubit(signOutUseCase: sl()),
  );

  sl.registerFactory<UserStatusCubit>(
    () => UserStatusCubit(setUserStatusUseCase: sl()),
  );

  // user bloc
  sl.registerFactory<UserListCubit>(
    () => UserListCubit(getAllUsersUsecase: sl.call()),
  );

  // chat bloc
  sl.registerFactory<ConversationCubit>(
    () => ConversationCubit(
      createConversationUseCase: sl(),
      getAllConversationUsecase: sl(),
      seenMessageUsecase: sl(),
    ),
  );

  sl.registerFactory<ConversationBloc>(
    () => ConversationBloc(
      createConversationUseCase: sl(),
      seenMessageUsecase: sl(),
      deleteConversationUseCase: sl(),
      editConversationUsecase: sl(),
    ),
  );

  sl.registerFactory<MessageCubit>(
    () => MessageCubit(
      sendMessageUseCase: sl(),
      getAllChatMessagesUseCase: sl(),
      unsendMessageUseCase: sl(),
      getAllSharedPhotosUseCase: sl(),
      getAllSharedVideosUseCase: sl(),
    ),
  );

  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(sendNotificationUseCase: sl()),
  );

  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(sendNotificationUseCase: sl()),
  );

  // call bloc
  sl.registerFactory<TokenBloc>(
    () => TokenBloc(getRtcTokenUsecase: sl()),
  );

  sl.registerFactory<CallBloc>(
    () => CallBloc(
      makeCallUsecase: sl(),
      getCallLogsUsecase: sl(),
    ),
  );

  // profile bloc
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getCurrentUserUseCase: sl(),
      editProfileUseCase: sl(),
    ),
  );

  // network bloc
  sl.registerFactory<NetworkBloc>(
    () => NetworkBloc(),
  );

  /// Usecase
  sl.registerLazySingleton<GooogleLoginUseCase>(
    () => GooogleLoginUseCase(repository: sl()),
  );

  sl.registerLazySingleton<FacebookLoginUseCase>(
    () => FacebookLoginUseCase(repository: sl()),
  );

  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(authRepository: sl()),
  );

  sl.registerLazySingleton<GetAllUsersUsecase>(
    () => GetAllUsersUsecase(chatRepository: sl()),
  );

  sl.registerLazySingleton<CreateConversationUseCase>(
    () => CreateConversationUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<UnsendMessageUseCase>(
    () => UnsendMessageUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<GetAllChatMessagesUseCase>(
    () => GetAllChatMessagesUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<GetAllConversationUsecase>(
    () => GetAllConversationUsecase(chatRepository: sl()),
  );

  sl.registerLazySingleton<GetAllSharedPhotosUseCase>(
    () => GetAllSharedPhotosUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<GetAllSharedVideosUseCase>(
    () => GetAllSharedVideosUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<SeenMessageUsecase>(
    () => SeenMessageUsecase(chatRepository: sl()),
  );

  sl.registerLazySingleton<DeleteConversationUseCase>(
    () => DeleteConversationUseCase(chatRepository: sl()),
  );

  sl.registerLazySingleton<EditConversationUsecase>(
    () => EditConversationUsecase(chatRepository: sl()),
  );

  sl.registerLazySingleton<SendNotificationUseCase>(
    () => SendNotificationUseCase(notificationRepository: sl()),
  );

  sl.registerLazySingleton<EditProfileUseCase>(
    () => EditProfileUseCase(profileRepository: sl()),
  );

  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(profileRepository: sl()),
  );

  sl.registerLazySingleton<SetUserStatusUseCase>(
    () => SetUserStatusUseCase(authRepository: sl()),
  );

  sl.registerLazySingleton<GetRtcTokenUsecase>(
    () => GetRtcTokenUsecase(callRepository: sl()),
  );

  sl.registerLazySingleton<MakeCallUsecase>(
    () => MakeCallUsecase(callRepository: sl()),
  );

  sl.registerLazySingleton<GetCallLogsUsecase>(
    () => GetCallLogsUsecase(callRepository: sl()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(chatRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<CallRepository>(
    () => CallRepositoryImpl(
      callRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(notificationRemoteDataSource: sl()),
  );

  /// Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl());

  sl.registerLazySingleton<CallRemoteDataSource>(
    () => CallRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl());

  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl());

  //!! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //!! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
