import 'package:internship_practice/features/chat/data/datasources/firebase_remote_data_source.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  const FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Stream<List<UserEntity>> getAllUsers() =>
      firebaseRemoteDataSource.getAllUsers();

  @override
  Future<String> createConversation(
      ConversationEntity conversationEntity) async {
    return await firebaseRemoteDataSource
        .createConversation(conversationEntity);
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    return await firebaseRemoteDataSource.sendMessage(messageEntity);
  }

  @override
  Stream<List<MessageEntity>> getAllMessages(String conversationId) =>
      firebaseRemoteDataSource.getAllMessages(conversationId);

  @override
  Stream<List<ConversationEntity>> getAllConversations() =>
      firebaseRemoteDataSource.getAllConversations();
}
