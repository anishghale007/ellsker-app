import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> googleSignIn();
  Future<Either<Failure, AuthUserEntity>> facebookSignIn();
  Future<void> signOut();
  Future<Either<Failure, void>> setUserStatus(bool isOnline);
}
