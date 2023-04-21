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
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list/user_list_cubit.dart';

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
    () => ConversationBloc(createConversationUseCase: sl()),
  );

  sl.registerFactory(
    () => MessageCubit(
      sendMessageUseCase: sl(),
      getAllMessagesUsecase: sl(),
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

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl()),
  );

  /// Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl());
}
