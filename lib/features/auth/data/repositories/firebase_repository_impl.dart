import 'package:internship_practice/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<void> googleSignIn() async {
    return await firebaseRemoteDataSource.googleSignIn();
  }
}
