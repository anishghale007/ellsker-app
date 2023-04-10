import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';

class GooogleLoginUseCase {
  final FirebaseRepository repository;

  GooogleLoginUseCase({required this.repository});

  Future<Either<Failure, GoogleUserEntity>> call() async {
    return await repository.googleSignIn();
  }
}
