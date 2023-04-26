import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllMessagesUsecase
    implements UseCase<Stream<List<MessageEntity>>, Param> {
  final FirebaseRepository firebaseRepository;

  const GetAllMessagesUsecase({required this.firebaseRepository});

  @override
  Future<Either<Failure, Stream<List<MessageEntity>>>> call(
      Param params) async {
    return await firebaseRepository.getAllMessages(params.conversationId);
  }
}

class Param extends Equatable {
  final String conversationId;

  const Param({required this.conversationId});
  @override
  List<Object?> get props => [conversationId];
}
