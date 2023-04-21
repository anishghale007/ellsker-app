import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllUsersUsecase
    implements UseCase<Stream<List<UserEntity>>, NoParams> {
  final FirebaseRepository firebaseRepository;

  const GetAllUsersUsecase({required this.firebaseRepository});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> call(NoParams noParams) {
    return firebaseRepository.getAllUsers();
  }
}
