import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  const ChatRepositoryImpl({required this.chatRemoteDataSource});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> getAllUsers() async {
    try {
      final usersData = chatRemoteDataSource.getAllUsers();
      return Right(usersData);
    } on ServerException {
      return Left(ServerFailure());
    }
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
  Future<Either<Failure, void>> unsendMessage({
    required conversationId,
    required messageId,
  }) async {
    try {
      final response = await chatRemoteDataSource.unsendMessage(
        conversationId: conversationId,
        messageId: messageId,
      );
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
      {required conversationId, required newNickname}) async {
    try {
      final response = await chatRemoteDataSource.editConversation(
        conversationId: conversationId,
        newNickname: newNickname,
      );
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
