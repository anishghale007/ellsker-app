import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:internship_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:internship_practice/features/auth/domain/entities/auth_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, AuthUserEntity>> googleSignIn() async {
    try {
      final userCredential = await authRemoteDataSource.googleSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> facebookSignIn() async {
    try {
      final userCredential = await authRemoteDataSource.facebookSignIn();
      return Right(userCredential);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<Either<Failure, void>> setUserStatus(bool isOnline) async {
    try {
      final setUserStatus = await authRemoteDataSource.setUserStatus(isOnline);
      return Right(setUserStatus);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
