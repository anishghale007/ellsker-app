import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_practice/features/chat/data/models/conversation_model.dart';
import 'package:internship_practice/features/chat/data/models/message_model.dart';
import 'package:internship_practice/features/chat/data/models/user_model.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Stream<List<UserEntity>> getAllUsers();
  Future<String> createConversation(ConversationEntity conversationEntity);
  Future<String> sendMessage(MessageEntity messageEntity);
  Future<bool> isExistentDocument();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return dbUser.snapshots().map(
        (event) => event.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<String> createConversation(
      ConversationEntity conversationEntity) async {
    try {
      if (await isExistentDocument()) {
        log("Document already exists");
      } else {
        // sender data
        final senderData = ConversationModel(
          receiverId: conversationEntity.receiverId,
          receiverName: conversationEntity.receiverName,
          receiverPhotoUrl: conversationEntity.receiverPhotoUrl,
          senderId: conversationEntity.senderId,
          senderName: conversationEntity.senderName,
          senderPhotoUrl: conversationEntity.senderPhotoUrl,
        ).toJson();
        dbUser
            .doc(conversationEntity.senderId)
            .collection("conversation")
            .doc(conversationEntity.receiverId)
            .set(senderData);
        // receiver data
        final receiverData = ConversationModel(
          receiverId: conversationEntity.senderId,
          receiverName: conversationEntity.senderName,
          receiverPhotoUrl: conversationEntity.senderPhotoUrl,
          senderId: conversationEntity.receiverId,
          senderName: conversationEntity.receiverName,
          senderPhotoUrl: conversationEntity.receiverPhotoUrl,
        ).toJson();
        dbUser
            .doc(conversationEntity.receiverId)
            .collection("conversation")
            .doc(conversationEntity.senderId)
            .set(receiverData);
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    try {
      // sender data
      final senderData = MessageModel(
        messageContent: messageEntity.messageContent,
        messageTime: messageEntity.messageTime,
        senderId: messageEntity.senderId,
        senderName: messageEntity.senderName,
        senderPhotoUrl: messageEntity.senderPhotoUrl,
        receiverId: messageEntity.receiverId,
        receiverName: messageEntity.receiverName,
        receiverPhotoUrl: messageEntity.receiverPhotoUrl,
      ).toJson();
      dbUser
          .doc(messageEntity.senderId)
          .collection("conversation")
          .doc(messageEntity.receiverId)
          .collection("message")
          .doc()
          .set(senderData);
      dbUser
          .doc(messageEntity.receiverId)
          .collection("conversation")
          .doc(messageEntity.senderId)
          .collection("message")
          .doc()
          .set(senderData);
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> isExistentDocument() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("conversation")
        .where('senderId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
