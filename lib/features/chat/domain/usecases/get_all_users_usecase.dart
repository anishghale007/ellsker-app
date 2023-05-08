import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class GetAllUsersUsecase
    implements UseCase<Stream<List<UserEntity>>, NoParams> {
  final ChatRepository chatRepository;

  const GetAllUsersUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> call(NoParams noParams) {
    return chatRepository.getAllUsers();
  }
}
