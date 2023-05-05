import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllConversationUsecase
    implements StreamUseCase<List<ConversationEntity>, NoParams> {
  final FirebaseRepository firebaseRepository;

  const GetAllConversationUsecase({required this.firebaseRepository});

  @override
  Stream<List<ConversationEntity>> call(NoParams noParams) {
    return firebaseRepository.getAllConversations();
  }
}
