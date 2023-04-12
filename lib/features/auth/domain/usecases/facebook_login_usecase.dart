import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/auth/domain/entities/facebook_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';

class FacebookLoginUseCase {
  final FirebaseRepository repository;

  const FacebookLoginUseCase({required this.repository});

  Future<Either<Failure, FacebookUserEntity>> call() async {
    return await repository.facebookSignIn();
  }
}
