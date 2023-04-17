import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/auth/domain/entities/facebook_user_entity.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, GoogleUserEntity>> googleSignIn() async {
    try {
      final userCredential = await authRemoteDataSource.googleSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FacebookUserEntity>> facebookSignIn() async {
    try {
      final userCredential = await authRemoteDataSource.facebookSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}