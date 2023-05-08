import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<Either<Failure, Stream<List<UserEntity>>>> getAllUsers();
  Future<Either<Failure, String>> createConversation(
      ConversationEntity conversationEntity);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<Either<Failure, String>> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId);
  Future<Either<Failure, void>> seenMessage(String conversationId);
  Future<Either<Failure, String>> deleteConversation(String conversationId);
  Future<Either<Failure, String>> editConversation(
      {required conversationId, required newNickname});
}
