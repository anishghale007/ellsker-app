import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_practice/features/chat/data/models/conversation_model.dart';
import 'package:internship_practice/features/chat/data/models/message_model.dart';
import 'package:internship_practice/features/chat/data/models/user_model.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:http/http.dart' as http;

abstract class FirebaseRemoteDataSource {
  Stream<List<UserEntity>> getAllUsers();
  Future<String> createConversation(ConversationEntity conversationEntity);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<String> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllMessages(String conversationId);
  Future<void> seenMessage(String conversationId);
  Future<bool> isExistentDocument();
  Future<String> sendNotification(NotificationEntity notificationEntity);
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
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
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
  Future<String> sendNotification(NotificationEntity notificationEntity) async {
    try {
      // FirebaseMessaging messaging = FirebaseMessaging.instance;

      // NotificationSettings settings = await messaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: false,
      //   provisional: false,
      //   sound: true,
      // );

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   print('User granted permission');
      // } else if (settings.authorizationStatus ==
      //     AuthorizationStatus.provisional) {
      //   print('User granted provisional permission');
      // } else {
      //   print('User declined or has not accepted permission');
      // }
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAdr6nbyo:APA91bFZBHMea1EOmdGMGeiuVY7CdzpykOcgFSAn7cHwh0RTYoMrY6iOKH4RXkcanq2OQPT6jeDYmfXkC5kN6g8Yp_xBNFtqVw7Oa5UTZqTh1Xq0Ere7BoJULhfENGvpm1SyAE5RfLxM',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click-action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': notificationEntity.body,
            'title': notificationEntity.title,
          },
          'notification': <String, dynamic>{
            'title': notificationEntity.title,
            'body': notificationEntity.body,
            'android_channel_id': 'internship_practice',
          },
          'to': notificationEntity.token,
        }),
      );
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
