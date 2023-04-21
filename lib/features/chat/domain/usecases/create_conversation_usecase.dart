import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class CreateConversationUseCase implements UseCase<String, Params> {
  final FirebaseRepository firebaseRepository;

  const CreateConversationUseCase({required this.firebaseRepository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await firebaseRepository
        .createConversation(params.conversationEntity);
  }
}

class Params extends Equatable {
  final ConversationEntity conversationEntity;

  const Params({required this.conversationEntity});

  @override
  List<Object?> get props => [conversationEntity];
}
