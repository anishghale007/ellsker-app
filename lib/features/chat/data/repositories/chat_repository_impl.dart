import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';
import 'package:internship_practice/features/chat/domain/usecases/edit_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/unsend_message_usecase.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  const ChatRepositoryImpl({required this.chatRemoteDataSource});

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return chatRemoteDataSource.getAllUsers();
  }

  @override
  Future<Either<Failure, String>> createConversation(
      ConversationEntity conversationEntity) async {
    try {
      final response =
          await chatRemoteDataSource.createConversation(conversationEntity);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteConversation(
      String conversationId) async {
    try {
      final response =
          await chatRemoteDataSource.deleteConversation(conversationId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendMessage(
      MessageEntity messageEntity) async {
    try {
      final response = await chatRemoteDataSource.sendMessage(messageEntity);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unsendMessage(
      UnsendMessageParams params) async {
    try {
      final response = await chatRemoteDataSource.unsendMessage(params);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> seenMessage(String conversationId) async {
    try {
      final response = await chatRemoteDataSource.seenMessage(conversationId);
      return Right(response);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId) {
    return chatRemoteDataSource.getAllChatMessages(conversationId);
  }

  @override
  Stream<List<ConversationEntity>> getAllConversations() {
    return chatRemoteDataSource.getAllConversations();
  }

  @override
  Future<Either<Failure, String>> editConversation(
      EditConversationParams params) async {
    try {
      final response = await chatRemoteDataSource.editConversation(params);
      return Right(response);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllSharedPhotos(
      String receiverId) async {
    try {
      final response =
          await chatRemoteDataSource.getAllSharedPhotos(receiverId);
      return Right(response);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllSharedVideos(
      String receiverId) async {
    try {
      final response =
          await chatRemoteDataSource.getAllSharedVideos(receiverId);
      return Right(response);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
