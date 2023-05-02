import 'package:get_it/get_it.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';
import 'package:internship_practice/features/auth/domain/usecases/facebook_login_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:internship_practice/features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:internship_practice/features/chat/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/chat/data/repositories/firebase_repository_impl.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';
import 'package:internship_practice/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_messages_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_users_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/seen_message_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/send_notification_usecase.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/bloc/notification/notification_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list/user_list_cubit.dart';
import 'package:internship_practice/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:internship_practice/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:internship_practice/features/profile/domain/repositories/profile_repository.dart';
import 'package:internship_practice/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:internship_practice/features/profile/domain/usecases/get_current_user_usecase.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';

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
    ),
  );

  sl.registerFactory<MessageCubit>(
    () => MessageCubit(
      sendMessageUseCase: sl(),
      getAllMessagesUsecase: sl(),
    ),
  );

  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(sendNotificationUseCase: sl()),
  );

  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(sendNotificationUseCase: sl()),
  );

  // profile bloc
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getCurrentUserUseCase: sl(),
      editProfileUseCase: sl(),
    ),
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
    () => GetAllUsersUsecase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<CreateConversationUseCase>(
    () => CreateConversationUseCase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<GetAllMessagesUsecase>(
    () => GetAllMessagesUsecase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<GetAllConversationUsecase>(
      () => GetAllConversationUsecase(firebaseRepository: sl()));

  sl.registerLazySingleton<SeenMessageUsecase>(
    () => SeenMessageUsecase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<SendNotificationUseCase>(
    () => SendNotificationUseCase(firebaseRepository: sl()),
  );

  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(profileRepository: sl()),
  );

  sl.registerLazySingleton<EditProfileUseCase>(
    () => EditProfileUseCase(profileRepository: sl()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemoteDataSource: sl()),
  );

  /// Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl());

  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl());
}
