import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/features/chat/data/models/conversation_model.dart';
import 'package:internship_practice/features/chat/data/models/message_model.dart';
import 'package:internship_practice/features/chat/data/models/user_model.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/usecases/edit_conversation_usecase.dart';
import 'package:internship_practice/features/chat/domain/usecases/unsend_message_usecase.dart';
import 'package:uuid/uuid.dart';

abstract class ChatRemoteDataSource {
  Stream<List<UserEntity>> getAllUsers();
  Future<String> createConversation(ConversationEntity conversationEntity);
  Future<String> deleteConversation(String conversationId);
  Stream<List<ConversationEntity>> getAllConversations();
  Future<String> sendMessage(MessageEntity messageEntity);
  Stream<List<MessageEntity>> getAllChatMessages(String conversationId);
  Future<List<String>> getAllSharedPhotos(String receiverId);
  Future<List<String>> getAllSharedVideos(String receiverId);
  Future<void> seenMessage(String conversationId);
  Future<void> unsendMessage(UnsendMessageParams params);
  Future<String> editConversation(EditConversationParams params);
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
        // checks if the document exists in the current user and receiver users collection
        log("Document already exists in the current user and the other user");
      } else {
        // creating a new conversation for both of the user
        log("Creating a new conversation for both of the user");
        // sender data
        _saveDataToConversationCollection(
          receiverId: conversationEntity.receiverId,
          receiverName: conversationEntity.receiverName,
          receiverNickname: conversationEntity.receiverNickname,
          receiverPhotoUrl: conversationEntity.receiverPhotoUrl,
          senderId: conversationEntity.senderId,
          senderName: conversationEntity.senderName,
          senderNickname: conversationEntity.senderNickname,
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
        _saveDataToConversationCollection(
          receiverId: conversationEntity.senderId,
          receiverName: conversationEntity.senderName,
          receiverNickname: conversationEntity.receiverNickname,
          receiverPhotoUrl: conversationEntity.senderPhotoUrl,
          senderId: conversationEntity.receiverId,
          senderName: conversationEntity.receiverName,
          senderNickname: conversationEntity.receiverNickname,
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
  Future<String> editConversation(EditConversationParams params) {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      // updating the conversation collection of the current user
      dbUser
          .doc(currentUser)
          .collection('conversation')
          .doc(params.conversationId)
          .update({
        "receiverNickname": params.newNickname,
      });
      // updating the conversation collection of the other user
      dbUser
          .doc(params.conversationId)
          .collection('conversation')
          .doc(currentUser)
          .update({
        "senderNickname": params.newNickname,
      });
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    try {
      String messageId = const Uuid().v1();
      if (messageEntity.photoFile != null) {
        // IF THE USER SENDS A PHOTO MESSAGE

        // saving the uploaded image to firebase
        final fileUrl = await _storeFileToFirebase(
          file: File(messageEntity.photoFile!.path),
          receiverId: messageEntity.receiverId,
          senderId: messageEntity.senderId,
          messageType: messageEntity.messageType,
          fileId: messageId,
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
          fileUrl: fileUrl,
          messageDocId: messageId,
          latitude: "",
          longitude: "",
          gifUrl: "",
        );
      } else if (messageEntity.videoFile != null) {
        // IF THE USERS SENDS A VIDEO MESSAGE

        // saving the uploaded image to firebase
        final fileUrl = await _storeFileToFirebase(
          file: File(messageEntity.videoFile!.path),
          receiverId: messageEntity.receiverId,
          senderId: messageEntity.senderId,
          messageType: messageEntity.messageType,
          fileId: messageId,
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
          fileUrl: fileUrl,
          messageDocId: messageId,
          latitude: "",
          longitude: "",
          gifUrl: "",
        );
      } else if (messageEntity.audioFile != null) {
        // IF THE USER SENDS AN AUDIO MESSAGE

        final fileUrl = await _storeFileToFirebase(
          file: File(messageEntity.audioFile!.path),
          receiverId: messageEntity.receiverId,
          senderId: messageEntity.senderId,
          messageType: messageEntity.messageType,
          fileId: messageId,
        );
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
          fileUrl: fileUrl,
          messageDocId: messageId,
          latitude: "",
          longitude: "",
          gifUrl: "",
        );
      } else if (messageEntity.gifUrl != null) {
        // IF THE USERS SENDS A GIF
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
          messageDocId: messageId,
          fileUrl: "",
          latitude: "",
          longitude: "",
          gifUrl: messageEntity.gifUrl!,
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
          messageDocId: messageId,
          fileUrl: "",
          latitude: messageEntity.latitude!,
          longitude: messageEntity.longitude!,
          gifUrl: "",
        );
      } else {
        // IF THE USER SENDS A TEXT MESSAGE
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
          messageDocId: messageId,
          latitude: "",
          longitude: "",
          fileUrl: "",
          gifUrl: "",
        );
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> unsendMessage(UnsendMessageParams params) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      _unsendMessageDataFromCollection(
        senderId: currentUser.uid,
        senderName: currentUser.displayName!,
        receiverId: params.conversationId,
        messageId: params.messageId,
      );
      _deleteFileFromFirbease(
        receiverId: params.receiverId,
        senderId: params.senderId,
        messageType: params.messageType,
        messageId: params.messageId,
      );
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

        message = event.docs.map((e) {
          final json = e.data();
          return MessageModel(
            messageId: e.id,
            messageContent: json['messageContent'] ?? '',
            messageTime: json['messageTime'] ?? '',
            senderId: json['senderId'] ?? '',
            senderName: json['senderName'] ?? '',
            senderPhotoUrl: json['senderPhotoUrl'] ?? '',
            receiverId: json['receiverId'] ?? '',
            receiverName: json['receiverName'] ?? '',
            receiverPhotoUrl: json['receiverPhotoUrl'] ?? '',
            messageType: (json['messageType'] as String).toEnum(),
            latitude: json['latitude'] ?? '',
            longitude: json['longitude'] ?? '',
            fileUrl: json['fileUrl'] ?? '',
            gifUrl: json['gifUrl'] ?? '',
          );
        }).toList();
        return message;
        // List<MessageEntity> message = [];
        // if (event.size == 0) {
        //   message = [];
        //   log("Empty collection");
        // } else {
        //   message =
        //       event.docs.map((e) => MessageModel.fromSnapshot(e)).toList();
        // }
        // return message;
      },
    );
  }

  @override
  Future<List<String>> getAllSharedPhotos(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    List<String> photoList = [];
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("chat/photos/$currentUser-$receiverId");
    final listResult = await storageRef.listAll();
    for (Reference ref in listResult.items) {
      final fileUrl = await ref.getDownloadURL();
      photoList.add(fileUrl);
      log("Photo List: $photoList");
    }
    return photoList;
  }

  @override
  Future<List<String>> getAllSharedVideos(String receiverId) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    List<String> videoList = [];
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("chat/videos/$currentUser-$receiverId");
    final listResult = await storageRef.listAll();
    for (Reference ref in listResult.items) {
      final fileUrl = await ref.getDownloadURL();
      videoList.add(fileUrl);
      log("Video List: $videoList");
    }
    return videoList;
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

  void _unsendMessageDataFromCollection({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String messageId,
  }) {
    // Deleting the message from both of the user collection
    dbUser
        .doc(senderId)
        .collection('conversation')
        .doc(receiverId)
        .collection('message')
        .doc(messageId)
        .delete();
    // Updating the current user conversation collection
    Map<String, dynamic> updateSenderConversationData = {
      "lastMessage": Constant.unsendMessageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": DateTime.now().toString(),
      "isSeen": true,
      "unSeenMessages": 0,
    };
    dbUser
        .doc(senderId)
        .collection('conversation')
        .doc(receiverId)
        .update(updateSenderConversationData);
    // Updating the receiver conversation collection
    dbUser
        .doc(receiverId)
        .collection('conversation')
        .doc(senderId)
        .collection('message')
        .doc(messageId)
        .delete();
    Map<String, dynamic> updateReceiverConversationData = {
      "lastMessage": Constant.unsendMessageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": DateTime.now().toString(),
      "isSeen": false,
      "unSeenMessages": FieldValue.increment(1),
    };
    dbUser
        .doc(receiverId)
        .collection('conversation')
        .doc(senderId)
        .update(updateReceiverConversationData);
  }

  void _saveDataToConversationCollection({
    required String receiverId,
    required String receiverName,
    required String receiverNickname,
    required String receiverPhotoUrl,
    required String senderId,
    required String senderName,
    required String senderNickname,
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
    final data = ConversationModel(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverNickname: receiverNickname,
      receiverPhotoUrl: receiverPhotoUrl,
      senderId: senderId,
      senderName: senderName,
      senderNickname: senderNickname,
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
    dbUser.doc(senderId).collection('conversation').doc(receiverId).set(data);
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
    required MessageType messageType,
    required String fileUrl,
    required String latitude,
    required String longitude,
    required String gifUrl,
    required String messageDocId,
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
      fileUrl: fileUrl,
      latitude: latitude,
      longitude: longitude,
      gifUrl: gifUrl,
    ).toJson();
    Map<String, dynamic> updateSenderConversationData = {
      "lastMessage": messageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": messageTime,
      "isSeen": true,
      "unSeenMessages": 0,
    };
    Map<String, dynamic> updateReceiverConversationData = {
      "lastMessage": messageContent,
      "lastMessageSenderName": senderName,
      "lastMessageSenderId": senderId,
      "lastMessageTime": messageTime,
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
        .doc(messageDocId)
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
        .doc(messageDocId)
        .set(senderData);
  }

  Future<void> _deleteFileFromFirbease({
    required String receiverId,
    required String senderId,
    required MessageType messageType,
    required String messageId,
  }) async {
    switch (messageType) {
      case MessageType.photo:
        // sender folder
        final senderFile = FirebaseStorage.instance
            .ref()
            .child('chat/photos/$senderId-$receiverId/$messageId');
        await senderFile.delete();
        // receiver folder
        final receiverFile = FirebaseStorage.instance
            .ref()
            .child('chat/photos/$receiverId-$senderId/$messageId');
        await receiverFile.delete();
        break;
      case MessageType.video:
        // sender folder
        final senderFile = FirebaseStorage.instance
            .ref()
            .child('chat/videos/$senderId-$receiverId/$messageId');
        await senderFile.delete();
        // receiver folder
        final receiverFile = FirebaseStorage.instance
            .ref()
            .child('chat/videos/$receiverId-$senderId/$messageId');
        await receiverFile.delete();
        break;
      case MessageType.audio:
        // sender folder
        final senderFile = FirebaseStorage.instance
            .ref()
            .child('chat/audio/$senderId-$receiverId/$messageId');
        await senderFile.delete();
        // receiver folder
        final receiverFile = FirebaseStorage.instance
            .ref()
            .child('chat/audio/$receiverId-$senderId/$messageId');
        await receiverFile.delete();
        break;
      default:
        null;
    }
  }

  Future<String> _storeFileToFirebase({
    required File file,
    required String receiverId,
    required String senderId,
    required MessageType messageType,
    required String fileId,
  }) async {
    // final imageId = "$senderId:UploadedAt:${DateTime.now().toString()}";
    switch (messageType) {
      case MessageType.photo:
        // sender folder
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('chat/photos/$senderId-$receiverId/$fileId')
            .putFile(file);
        // receiver folder
        await FirebaseStorage.instance
            .ref()
            .child("chat/photos/$receiverId-$senderId/$fileId")
            .putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String newFileUrl = await snapshot.ref.getDownloadURL();
        return newFileUrl;
      case MessageType.video:
        // sender folder
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('chat/videos/$senderId-$receiverId/$fileId')
            .putFile(file);
        // receiver folder
        await FirebaseStorage.instance
            .ref()
            .child("chat/videos/$receiverId-$senderId/$fileId")
            .putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String newFileUrl = await snapshot.ref.getDownloadURL();
        return newFileUrl;
      default:
        // sender folder
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('chat/audio/$senderId-$receiverId/$fileId')
            .putFile(file);
        // receiver folder
        await FirebaseStorage.instance
            .ref()
            .child("chat/audio/$receiverId-$senderId/$fileId")
            .putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String newFileUrl = await snapshot.ref.getDownloadURL();
        return newFileUrl;
    }
  }
}
