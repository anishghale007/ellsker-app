import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/auth/domain/entities/facebook_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class FacebookLoginUseCase implements UseCase<FacebookUserEntity, NoParams> {
  final AuthRepository repository;

  const FacebookLoginUseCase({required this.repository});

  @override
  Future<Either<Failure, FacebookUserEntity>> call(NoParams noParams) async {
    return await repository.facebookSignIn();
  }
}
