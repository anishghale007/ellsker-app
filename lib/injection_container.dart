import 'package:get_it/get_it.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';
import 'package:internship_practice/features/auth/domain/usecases/facebook_login_usecase.dart';
import 'package:internship_practice/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:internship_practice/features/auth/presentation/bloc/facebook_sign_in/facebook_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign_out_cubit.dart';
import 'package:internship_practice/features/chat/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/chat/data/repositories/firebase_repository_impl.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';
import 'package:internship_practice/features/chat/domain/usecases/get_all_users_usecase.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list_cubit.dart';

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

  /// Usecase
  sl.registerLazySingleton<GooogleLoginUseCase>(
    () => GooogleLoginUseCase(repository: sl()),
  );

  sl.registerLazySingleton<FacebookLoginUseCase>(
    () => FacebookLoginUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetAllUsersUsecase>(
    () => GetAllUsersUsecase(firebaseRepository: sl()),
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
