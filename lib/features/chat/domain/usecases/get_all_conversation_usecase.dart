import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllConversationUsecase {
  final FirebaseRepository firebaseRepository;

  const GetAllConversationUsecase({required this.firebaseRepository});

  Stream<List<ConversationEntity>> call() {
    return firebaseRepository.getAllConversations();
  }
}
