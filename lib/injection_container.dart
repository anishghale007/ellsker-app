import 'package:get_it/get_it.dart';
import 'package:internship_practice/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/auth/data/repositories/firebase_repository_impl.dart';
import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';
import 'package:internship_practice/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:internship_practice/features/auth/presentation/bloc/google_sign_in_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// BLoC
  ///
  // auth bloc
  sl.registerFactory<GoogleSignInBloc>(
    () => GoogleSignInBloc(gooogleLoginUseCase: sl()),
  );

  /// Usecase
  sl.registerLazySingleton<GooogleLoginUseCase>(
    () => GooogleLoginUseCase(repository: sl()),
  );

  /// Repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl()),
  );

  /// Data Sources
  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl());
}
