import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllMessagesUsecase {
  final FirebaseRepository firebaseRepository;

  const GetAllMessagesUsecase({required this.firebaseRepository});

  Stream<List<MessageEntity>> call(String conversationId) {
    return firebaseRepository.getAllMessages(conversationId);
  }
}
