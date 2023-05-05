import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllChatMessagesUseCase
    extends StreamUseCase<List<MessageEntity>, GetAllChatMessagesParams> {
  final FirebaseRepository firebaseRepository;

  GetAllChatMessagesUseCase({required this.firebaseRepository});
  @override
  Stream<List<MessageEntity>> call(GetAllChatMessagesParams params) {
    return firebaseRepository.getAllChatMessages(params.conversationId);
  }
}

class GetAllChatMessagesParams extends Equatable {
  final String conversationId;

  const GetAllChatMessagesParams({required this.conversationId});
  @override
  List<Object?> get props => throw UnimplementedError();
}
