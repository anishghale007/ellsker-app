import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class SendMessageUseCase {
  final FirebaseRepository firebaseRepository;

  const SendMessageUseCase({required this.firebaseRepository});

  Future<String> call(MessageEntity messageEntity) async {
    return await firebaseRepository.sendMessage(messageEntity);
  }
}
