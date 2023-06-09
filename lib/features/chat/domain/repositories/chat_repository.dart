import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/edit_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/unsend_message_usecase.dart';

abstract class ChatRepository {
  Stream<List<UserEntity>> getAllUsers();
  Future<Either<Failure, String>> createConversation(
      ConversationEntity conversationEntity);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<Either<Failure, String>> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId);
  Future<Either<Failure, List<String>>> getAllSharedPhotos(String receiverId);
  Future<Either<Failure, List<String>>> getAllSharedVideos(String receiverId);
  Future<Either<Failure, void>> seenMessage(String conversationId);
  Future<Either<Failure, void>> unsendMessage(UnsendMessageParams params);
  Future<Either<Failure, String>> deleteConversation(String conversationId);
  Future<Either<Failure, String>> editConversation(
      EditConversationParams params);
}
