import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';

abstract class FirebaseRepository {
  Future<Either<Failure, GoogleUserEntity>> googleSignIn();
}
