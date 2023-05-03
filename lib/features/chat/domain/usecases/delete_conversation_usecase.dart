import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class DeleteConversationUseCase implements UseCase<String, Parameters> {
  final FirebaseRepository firebaseRepository;

  const DeleteConversationUseCase({required this.firebaseRepository});

  @override
  Future<Either<Failure, String>> call(Parameters params) async {
    return await firebaseRepository.deleteConversation(params.conversationId);
  }
}

class Parameters extends Equatable {
  final String conversationId;

  const Parameters({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
