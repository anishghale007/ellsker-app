import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatMessagesUseCase
    extends StreamUseCase<List<MessageEntity>, GetAllChatMessagesParams> {
  final ChatRepository chatRepository;

  GetAllChatMessagesUseCase({required this.chatRepository});
  @override
  Stream<List<MessageEntity>> call(GetAllChatMessagesParams params) {
    return chatRepository.getAllChatMessages(params.conversationId);
  }
}

class GetAllChatMessagesParams extends Equatable {
  final String conversationId;

  const GetAllChatMessagesParams({required this.conversationId});
  @override
  List<Object?> get props => [conversationId];
}
