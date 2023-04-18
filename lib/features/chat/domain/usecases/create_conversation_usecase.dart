import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class CreateConversationUseCase {
  final FirebaseRepository firebaseRepository;

  const CreateConversationUseCase({required this.firebaseRepository});

  Future<String> call(ConversationEntity conversationEntity) async {
    return await firebaseRepository.createConversation(conversationEntity);
  }
}
