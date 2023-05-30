import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class EditConversationUsecase
    implements UseCase<String, EditConversationParams> {
  final ChatRepository chatRepository;

  const EditConversationUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, String>> call(EditConversationParams params) async {
    return await chatRepository.editConversation(params);
  }
}

class EditConversationParams extends Equatable {
  final String conversationId;
  final String newNickname;

  const EditConversationParams({
    required this.conversationId,
    required this.newNickname,
  });

  @override
  List<Object?> get props => [conversationId, newNickname];
}
