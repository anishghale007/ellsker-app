import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/auth/domain/entities/auth_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class FacebookLoginUseCase implements UseCase<AuthUserEntity, NoParams> {
  final AuthRepository repository;

  const FacebookLoginUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthUserEntity>> call(NoParams noParams) async {
    return await repository.facebookSignIn();
  }
}
