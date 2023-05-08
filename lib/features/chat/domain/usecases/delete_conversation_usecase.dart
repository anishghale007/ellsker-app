import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class DeleteConversationUseCase
    implements UseCase<String, DeleteConversationParams> {
  final ChatRepository chatRepository;

  const DeleteConversationUseCase({required this.chatRepository});

  @override
  Future<Either<Failure, String>> call(DeleteConversationParams params) async {
    return await chatRepository.deleteConversation(params.conversationId);
  }
}

class DeleteConversationParams extends Equatable {
  final String conversationId;

  const DeleteConversationParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
