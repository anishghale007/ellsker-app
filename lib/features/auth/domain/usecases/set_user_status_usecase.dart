import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class SetUserStatusUseCase implements UseCase<void, SetUserStatusParams> {
  final AuthRepository authRepository;

  const SetUserStatusUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(SetUserStatusParams params) async {
    return await authRepository.setUserStatus(params.isOnline);
  }
}

class SetUserStatusParams extends Equatable {
  final bool isOnline;

  const SetUserStatusParams({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
