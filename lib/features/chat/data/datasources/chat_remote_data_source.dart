import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship_practice/features/chat/data/models/conversation_model.dart';
import 'package:internship_practice/features/chat/data/models/message_model.dart';
import 'package:internship_practice/features/chat/data/models/user_model.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class ChatRemoteDataSource {
  Stream<List<UserEntity>> getAllUsers();
  Future<String> createConversation(ConversationEntity conversationEntity);
  Future<String> deleteConversation(String conversationId);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<String> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId);
  Future<void> seenMessage(String conversationId);
  Future<String> editConversation(
      {required String conversationId, required String newNickname});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
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
      if (await isExistentConversationDocument() &&
          await isExistentConversationDocumentAtOtherUser(
              conversationEntity.receiverId)) {
        // checks if the document exists in the current user collection
        log("Document already exists in the current user");
        // }
        // else if (await isNotExistentConversationDocumentAtOtherUser(
        //     conversationEntity.receiverId)) {
        //   // checks if the document exists in both of the user collection. Used if the receiver deletes the conversation
        //   log("Document does not exist in the other user. Creating it now");
        //   // sender data
        //   _saveSenderDataToConversationCollection(
        //     receiverId: conversationEntity.receiverId,
        //     receiverName: conversationEntity.receiverName,
        //     receiverPhotoUrl: conversationEntity.receiverPhotoUrl,
        //     senderId: conversationEntity.senderId,
        //     senderName: conversationEntity.senderName,
        //     senderPhotoUrl: conversationEntity.senderPhotoUrl,
        //     lastMessage: conversationEntity.lastMessage,
        //     lastMessageSenderName: conversationEntity.lastMessageSenderName,
        //     lastMessageSenderId: conversationEntity.lastMessageSenderId,
        //     lastMessageTime: conversationEntity.lastMessageTime,
        //     isSeen: conversationEntity.isSeen,
        //     unSeenMessages: conversationEntity.unSeenMessages,
        //     senderToken: conversationEntity.senderToken,
        //     receiverToken: conversationEntity.receiverToken,
        //   );
        //   // receiver data
        //   _saveReceiverDataToConversationCollection(
        //     receiverId: conversationEntity.senderId,
        //     receiverName: conversationEntity.senderName,
        //     receiverPhotoUrl: conversationEntity.senderPhotoUrl,
        //     senderId: conversationEntity.receiverId,
        //     senderName: conversationEntity.receiverName,
        //     senderPhotoUrl: conversationEntity.receiverPhotoUrl,
        //     lastMessage: conversationEntity.lastMessage,
        //     lastMessageSenderName: conversationEntity.lastMessageSenderName,
        //     lastMessageSenderId: conversationEntity.lastMessageSenderId,
        //     lastMessageTime: conversationEntity.lastMessageTime,
        //     isSeen: conversationEntity.isSeen,
        //     unSeenMessages: conversationEntity.unSeenMessages,
        //     senderToken: conversationEntity.receiverToken,
        //     receiverToken: conversationEntity.senderToken,
        //   );
      } else {
        // creating a new conversation for both of the user
        log("Creating a new conversation for both of the user");
        // sender data
        _saveSenderDataToConversationCollection(
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
        );
        // receiver data
        _saveReceiverDataToConversationCollection(
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
        );
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
  Future<String> editConversation(
      {required String conversationId, required String newNickname}) {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      // updating the conversation collection of the current user
      dbUser
          .doc(currentUser)
          .collection('conversation')
          .doc(conversationId)
          .update({
        "receiverName": newNickname,
      });
      // updating the conversation collection of the other user
      dbUser
          .doc(conversationId)
          .collection('conversation')
          .doc(currentUser)
          .update({
        "senderName": newNickname,
      });
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    try {
      if (messageEntity.image != null) {
        // IF THE USER SENDS A PHOTO MESSAGE
        // final imageId =
        //     "${messageEntity.senderId}:UploadedAt:${DateTime.now().toString()}";
        // final imageStorage = FirebaseStorage.instance.ref().child(
        //     '${messageEntity.senderId}-${messageEntity.receiverId}/$imageId');
        // final imageFile = File(messageEntity.image!.path);
        // await imageStorage.putFile(imageFile);
        // final photoUrl = await imageStorage.getDownloadURL();

        final photoUrl = await _storeImageToFirebase(
          file: File(messageEntity.image!.path),
          receiverId: messageEntity.receiverId,
          senderId: messageEntity.senderId,
        );

        // saving the data
        _saveMessageDataToMessageCollection(
          messageContent: messageEntity.messageContent,
          messageTime: messageEntity.messageTime,
          senderId: messageEntity.senderId,
          senderName: messageEntity.senderName,
          senderPhotoUrl: messageEntity.senderPhotoUrl,
          receiverId: messageEntity.receiverId,
          receiverName: messageEntity.receiverName,
          receiverPhotoUrl: messageEntity.receiverPhotoUrl,
          messageType: messageEntity.messageType,
          photoUrl: photoUrl,
          latitude: "",
          longitude: "",
        );
      } else if (messageEntity.latitude != null ||
          messageEntity.longitude != null) {
        // IF THE USER SENDS A LOCATION MESSAGE
        _saveMessageDataToMessageCollection(
          messageContent: messageEntity.messageContent,
          messageTime: messageEntity.messageTime,
          senderId: messageEntity.senderId,
          senderName: messageEntity.senderName,
          senderPhotoUrl: messageEntity.senderPhotoUrl,
          receiverId: messageEntity.receiverId,
          receiverName: messageEntity.receiverName,
          receiverPhotoUrl: messageEntity.receiverPhotoUrl,
          messageType: messageEntity.messageType,
          photoUrl: "",
          latitude: messageEntity.latitude!,
          longitude: messageEntity.longitude!,
        );
      } else {
        // IF THE USER SENDS A TEXT MESSAGE
        // saving the data
        _saveMessageDataToMessageCollection(
          messageContent: messageEntity.messageContent,
          messageTime: messageEntity.messageTime,
          senderId: messageEntity.senderId,
          senderName: messageEntity.senderName,
          senderPhotoUrl: messageEntity.senderPhotoUrl,
          receiverId: messageEntity.receiverId,
          receiverName: messageEntity.receiverName,
          receiverPhotoUrl: messageEntity.receiverPhotoUrl,
          messageType: messageEntity.messageType,
          latitude: "",
          longitude: "",
          photoUrl: "",
        );
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return dbUser
        .doc(currentUser)
        .collection("conversation")
        .doc(conversationId)
        .collection("message")
        .orderBy("messageTime")
        .snapshots()
        .map(
      (event) {
        List<MessageEntity> message = [];
        if (event.size == 0) {
          message = [];
          log("Empty collection");
        } else {
          message =
              event.docs.map((e) => MessageModel.fromSnapshot(e)).toList();
        }
        return message;
      },
    );
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

  Future<bool> isExistentConversationDocument() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("conversation")
        .where('senderId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isExistentConversationDocumentAtOtherUser(
      String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("conversation")
        .where('receiverId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isNotExistentConversationDocumentAtOtherUser(
      String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('conversation')
        .where('receiverId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  void _saveSenderDataToConversationCollection({
    required String receiverId,
    required String receiverName,
    required String receiverPhotoUrl,
    required String senderId,
    required String senderName,
    required String senderPhotoUrl,
    required String lastMessage,
    required String lastMessageSenderName,
    required String lastMessageSenderId,
    required String lastMessageTime,
    required bool isSeen,
    required int unSeenMessages,
    required String senderToken,
    required String receiverToken,
  }) {
    final senderData = ConversationModel(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPhotoUrl: receiverPhotoUrl,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      lastMessage: lastMessage,
      lastMessageSenderName: lastMessageSenderName,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageTime: lastMessageTime,
      isSeen: isSeen,
      unSeenMessages: unSeenMessages,
      senderToken: senderToken,
      receiverToken: receiverToken,
    ).toJson();
    dbUser
        .doc(senderId)
        .collection('conversation')
        .doc(receiverId)
        .set(senderData);
  }

  void _saveReceiverDataToConversationCollection({
    required String receiverId,
    required String receiverName,
    required String receiverPhotoUrl,
    required String senderId,
    required String senderName,
    required String senderPhotoUrl,
    required String lastMessage,
    required String lastMessageSenderName,
    required String lastMessageSenderId,
    required String lastMessageTime,
    required bool isSeen,
    required int unSeenMessages,
    required String senderToken,
    required String receiverToken,
  }) {
    final receiverData = ConversationModel(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPhotoUrl: receiverPhotoUrl,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      lastMessage: lastMessage,
      lastMessageSenderName: lastMessageSenderName,
      lastMessageSenderId: lastMessageSenderId,
      lastMessageTime: lastMessageTime,
      isSeen: isSeen,
      unSeenMessages: unSeenMessages,
      senderToken: senderToken,
      receiverToken: receiverToken,
    ).toJson();
    dbUser
        .doc(senderId)
        .collection('conversation')
        .doc(receiverId)
        .set(receiverData);
  }

  void _saveMessageDataToMessageCollection({
    required String messageContent,
    required String messageTime,
    required String senderId,
    required String senderName,
    required String senderPhotoUrl,
    required String receiverId,
    required String receiverName,
    required String receiverPhotoUrl,
    required String messageType,
    required String photoUrl,
    required String latitude,
    required String longitude,
  }) {
    final senderData = MessageModel(
      messageContent: messageContent,
      messageTime: messageTime,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPhotoUrl: receiverPhotoUrl,
      messageType: messageType,
      photoUrl: photoUrl,
      latitude: latitude,
      longitude: longitude,
    ).toJson();
    Map<String, dynamic> updateSenderConversationData = {
      "lastMessage": messageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": messageTime,
      "messageType": messageType,
      "isSeen": true,
      "unSeenMessages": 0,
    };
    Map<String, dynamic> updateReceiverConversationData = {
      "lastMessage": messageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": messageTime,
      "messageType": messageType,
      "isSeen": false,
      "unSeenMessages": FieldValue.increment(1),
    };
    // sender data
    dbUser
        .doc(senderId)
        .collection("conversation")
        .doc(receiverId)
        .update(updateSenderConversationData);
    dbUser
        .doc(senderId)
        .collection("conversation")
        .doc(receiverId)
        .collection("message")
        .doc()
        .set(senderData);
    // receiver data
    dbUser
        .doc(receiverId)
        .collection("conversation")
        .doc(senderId)
        .update(updateReceiverConversationData);
    dbUser
        .doc(receiverId)
        .collection("conversation")
        .doc(senderId)
        .collection("message")
        .doc()
        .set(senderData);
  }

  Future<String> _storeImageToFirebase({
    required File file,
    required String receiverId,
    required String senderId,
  }) async {
    final imageId = "$senderId:UploadedAt:${DateTime.now().toString()}";

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('$senderId-$receiverId/$imageId')
        .putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String newPhotoUrl = await snapshot.ref.getDownloadURL();
    return newPhotoUrl;
  }
}
