import 'package:dartz/dartz.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/chat/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  const FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<Either<Failure, Stream<List<UserEntity>>>> getAllUsers() async {
    try {
      final usersData = firebaseRemoteDataSource.getAllUsers();
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
          await firebaseRemoteDataSource.createConversation(conversationEntity);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    return await firebaseRemoteDataSource.sendMessage(messageEntity);
  }

  @override
  Future<void> seenMessage(String conversationId) async {
    return await firebaseRemoteDataSource.seenMessage(conversationId);
  }

  @override
  Stream<List<MessageEntity>> getAllMessages(String conversationId) =>
      firebaseRemoteDataSource.getAllMessages(conversationId);

  @override
  Future<Either<Failure, Stream<List<ConversationEntity>>>>
      getAllConversations() async {
    try {
      final response = firebaseRemoteDataSource.getAllConversations();
      return right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
