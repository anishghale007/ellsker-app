import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<Either<Failure, Stream<List<UserEntity>>>> getAllUsers();
  Future<Either<Failure, String>> createConversation(
      ConversationEntity conversationEntity);
  Future<Either<Failure, Stream<List<ConversationEntity>>>>
      getAllConversations();
  Future<Either<Failure, String>> sendMessage(MessageEntity messageEntity);
  Future<Either<Failure, Stream<List<MessageEntity>>>> getAllMessages(
      String conversationId);
  Future<Either<Failure, void>> seenMessage(String conversationId);
}
