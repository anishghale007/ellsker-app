import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/auth/domain/entities/google_user_entity.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class GooogleLoginUseCase implements UseCase<GoogleUserEntity, NoParams> {
  final AuthRepository repository;

  GooogleLoginUseCase({required this.repository});

  @override
  Future<Either<Failure, GoogleUserEntity>> call(NoParams noParams) async {
    return await repository.googleSignIn();
  }
}
