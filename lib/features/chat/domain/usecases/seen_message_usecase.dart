import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class SeenMessageUsecase {
  final FirebaseRepository firebaseRepository;

  const SeenMessageUsecase({required this.firebaseRepository});

  Future<void> call(String conversationId) async {
    return await firebaseRepository.seenMessage(conversationId);
  }
}
