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
  Future<String> deleteConversation(String conversationId);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<String> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllMessages(String conversationId);
  Future<void> seenMessage(String conversationId);
  Future<bool> isExistentDocument();
  Future<bool> isNotExistentAtOtherUserDocument(String receiverId);
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser!;

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
        // checks the document of current user
        log("Document already exists in the current user");
      } else if (await isNotExistentAtOtherUserDocument(
          conversationEntity.receiverId)) {
        log("Document does not exist in the other user. Creating it now");
        // sender data
        final senderData = ConversationModel(
          receiverId: conversationEntity.receiverId,
          receiverName: conversationEntity.receiverName,
          receiverPhotoUrl: conversationEntity.receiverPhotoUrl,
          senderId: conversationEntity.senderId,
          senderName: conversationEntity.senderName,
          senderPhotoUrl: conversationEntity.senderPhotoUrl,
          lastMessage: conversationEntity.lastMessage,
          lastMessageSenderName: conversationEntity.lastMessageSenderName,
          lastMessageSenderId: conversationEntity.lastMessageSenderId,
          lastMessageTime: conversationEntity.lastMessageTime,
          isSeen: conversationEntity.isSeen,
          unSeenMessages: conversationEntity.unSeenMessages,
          senderToken: conversationEntity.senderToken,
          receiverToken: conversationEntity.receiverToken,
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
          lastMessage: conversationEntity.lastMessage,
          lastMessageSenderName: conversationEntity.lastMessageSenderName,
          lastMessageSenderId: conversationEntity.lastMessageSenderId,
          lastMessageTime: conversationEntity.lastMessageTime,
          isSeen: conversationEntity.isSeen,
          unSeenMessages: conversationEntity.unSeenMessages,
          senderToken: conversationEntity.receiverToken,
          receiverToken: conversationEntity.senderToken,
        ).toJson();
        dbUser
            .doc(conversationEntity.receiverId)
            .collection("conversation")
            .doc(conversationEntity.senderId)
            .set(receiverData);
      } else {
        // sender data
        final senderData = ConversationModel(
          receiverId: conversationEntity.receiverId,
          receiverName: conversationEntity.receiverName,
          receiverPhotoUrl: conversationEntity.receiverPhotoUrl,
          senderId: conversationEntity.senderId,
          senderName: conversationEntity.senderName,
          senderPhotoUrl: conversationEntity.senderPhotoUrl,
          lastMessage: conversationEntity.lastMessage,
          lastMessageSenderName: conversationEntity.lastMessageSenderName,
          lastMessageSenderId: conversationEntity.lastMessageSenderId,
          lastMessageTime: conversationEntity.lastMessageTime,
          isSeen: conversationEntity.isSeen,
          unSeenMessages: conversationEntity.unSeenMessages,
          senderToken: conversationEntity.senderToken,
          receiverToken: conversationEntity.receiverToken,
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
          lastMessage: conversationEntity.lastMessage,
          lastMessageSenderName: conversationEntity.lastMessageSenderName,
          lastMessageSenderId: conversationEntity.lastMessageSenderId,
          lastMessageTime: conversationEntity.lastMessageTime,
          isSeen: conversationEntity.isSeen,
          unSeenMessages: conversationEntity.unSeenMessages,
          senderToken: conversationEntity.receiverToken,
          receiverToken: conversationEntity.senderToken,
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
  Future<String> deleteConversation(String conversationId) async {
    try {
      // Deleting the conversation doc from the current user
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      dbUser
          .doc(currentUser)
          .collection('conversation')
          .doc(conversationId)
          .delete();
      var messageCollection = await dbUser
          .doc(currentUser)
          .collection('conversation')
          .doc(conversationId)
          .collection('message')
          .get();
      for (var doc in messageCollection.docs) {
        await doc.reference.delete();
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ConversationEntity>> getAllConversations() {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return dbUser.doc(currentUser).collection("conversation").snapshots().map(
        (event) =>
            event.docs.map((e) => ConversationModel.fromSnapshot(e)).toList());
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
      Map<String, dynamic> updateSenderConversationData = {
        "lastMessage": messageEntity.messageContent,
        "lastMessageSenderName": messageEntity.senderName,
        "lastMessageSenderId": messageEntity.senderId,
        "lastMessageTime": messageEntity.messageTime,
        "isSeen": true,
        "unSeenMessages": 0,
      };
      Map<String, dynamic> updateReceiverConversationData = {
        "lastMessage": messageEntity.messageContent,
        "lastMessageSenderName": messageEntity.senderName,
        "lastMessageSenderId": messageEntity.senderId,
        "lastMessageTime": messageEntity.messageTime,
        "isSeen": false,
        "unSeenMessages": FieldValue.increment(1),
      };
      dbUser
          .doc(messageEntity.senderId)
          .collection("conversation")
          .doc(messageEntity.receiverId)
          .update(updateSenderConversationData);
      dbUser
          .doc(messageEntity.senderId)
          .collection("conversation")
          .doc(messageEntity.receiverId)
          .collection("message")
          .doc()
          .set(senderData);
      // receiver data
      dbUser
          .doc(messageEntity.receiverId)
          .collection("conversation")
          .doc(messageEntity.senderId)
          .update(updateReceiverConversationData);
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
  Stream<List<MessageEntity>> getAllMessages(String conversationId) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return dbUser
        .doc(currentUser)
        .collection("conversation")
        .doc(conversationId)
        .collection("message")
        .orderBy("messageTime")
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessageModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> seenMessage(String conversationId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    try {
      Map<String, dynamic> updateSenderConversationData = {
        "isSeen": true,
        "unSeenMessages": 0,
      };
      dbUser
          .doc(currentUser)
          .collection("conversation")
          .doc(conversationId)
          .update(updateSenderConversationData);
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

  @override
  Future<bool> isNotExistentAtOtherUserDocument(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('conversation')
        .where('receiverId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isEmpty;
  }
}
