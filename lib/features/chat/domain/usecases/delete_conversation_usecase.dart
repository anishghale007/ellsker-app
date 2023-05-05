import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class DeleteConversationUseCase
    implements UseCase<String, DeleteConversationParams> {
  final FirebaseRepository firebaseRepository;

  const DeleteConversationUseCase({required this.firebaseRepository});

  @override
  Future<Either<Failure, String>> call(DeleteConversationParams params) async {
    return await firebaseRepository.deleteConversation(params.conversationId);
  }
}

class DeleteConversationParams extends Equatable {
  final String conversationId;

  const DeleteConversationParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
