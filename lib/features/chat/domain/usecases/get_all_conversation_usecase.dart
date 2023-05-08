import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class GetAllConversationUsecase
    implements StreamUseCase<List<ConversationEntity>, NoParams> {
  final ChatRepository chatRepository;

  const GetAllConversationUsecase({required this.chatRepository});

  @override
  Stream<List<ConversationEntity>> call(NoParams noParams) {
    return chatRepository.getAllConversations();
  }
}
