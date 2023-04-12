import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/auth/domain/entities/facebook_user_entity.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<Either<Failure, GoogleUserEntity>> googleSignIn() async {
    try {
      final userCredential = await firebaseRemoteDataSource.googleSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FacebookUserEntity>> facebookSignIn() async {
    try {
      final userCredential = await firebaseRemoteDataSource.facebookSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
