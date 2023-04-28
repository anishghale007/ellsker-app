import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship_practice/features/profile/data/models/user_profile_model.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Stream<UserProfileEntity> getCurrentUser();
  Future<String> editProfile(UserProfileEntity userProfileEntity);
  Future<bool> isMessageSender();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Stream<UserProfileEntity> getCurrentUser() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      // return dbUser
      //     .doc(currentUser)
      //     .snapshots()
      //     .map((event) => UserProfileModel.fromSnapshot(event));
      final user = dbUser.where('userId', isEqualTo: currentUser).snapshots();
      return user.map((event) => singleUser(event));
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  UserProfileModel singleUser(QuerySnapshot querySnapshot) {
    final singleData = querySnapshot.docs[0].data() as Map<String, dynamic>;
    return UserProfileModel.fromJson(singleData);
  }

  @override
  Future<String> editProfile(UserProfileEntity userProfileEntity) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      if (userProfileEntity.image != null) {
        // If the user uploads a new profile picture
        final newImageId =
            "${userProfileEntity.email}:UploadedAt:${DateTime.now().toString()}";
        final newImageStorage = FirebaseStorage.instance
            .ref()
            .child('${userProfileEntity.email}/$newImageId');
        final newImageFile = File(userProfileEntity.image!.path);
        await newImageStorage.putFile(newImageFile);
        final newPhotoUrl = await newImageStorage.getDownloadURL();
        // updating the User Collection
        await dbUser.doc(currentUser).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
          'photoUrl': newPhotoUrl,
        });

        // updating the conversation collection of the current user
        var currentUserConversationCollection =
            await dbUser.doc(currentUser).collection('conversation').get();
        for (var doc in currentUserConversationCollection.docs) {
          await doc.reference.update({
            'senderName': userProfileEntity.username,
            'senderPhotoUrl': newPhotoUrl,
          });
        }
        // updating the conversation collection of the other user
        // var otherUserConversationCollection = await FirebaseFirestore.instance
        //     .collectionGroup('conversation')
        //     .where('senderId', isNotEqualTo: currentUser)
        //     .get();
        // for (var doc in otherUserConversationCollection.docs) {
        //   await doc.reference.update({
        //     'receiverName': userProfileEntity.username,
        //     'receiverPhotoUrl': newPhotoUrl,
        //   });
        // }
        // updating the message collection
        var messageCollection = await dbUser
            .doc(currentUser)
            .collection('conversation')
            .doc()
            .collection('message')
            .get();
        if (await isMessageSender()) {
          // if the current user is the message sender
          for (var doc in messageCollection.docs) {
            await doc.reference.update({
              'senderName': userProfileEntity.username,
              'senderPhotoUrl': newPhotoUrl,
            });
          }
        } else {
          // if the current user is not the message sender
          for (var doc in messageCollection.docs) {
            await doc.reference.update({
              'receiverName': userProfileEntity.username,
              'receiverPhotoUrl': newPhotoUrl,
            });
          }
        }
      } else {
        // if the user does not upload a new profile picture
        // updating the User Collection
        await dbUser.doc(currentUser).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
        });
        // updating the conversation collection
        var conversationCollection =
            await dbUser.doc(currentUser).collection('conversation').get();
        for (var doc in conversationCollection.docs) {
          await doc.reference.update({
            'senderName': userProfileEntity.username,
          });
        }
        var messageCollection = await dbUser
            .doc(currentUser)
            .collection('conversation')
            .doc()
            .collection('message')
            .get();
        // updating the message collection
        if (await isMessageSender()) {
          // if the current user is the message sender
          for (var doc in messageCollection.docs) {
            await doc.reference.update({
              'senderName': userProfileEntity.username,
            });
          }
        } else {
          // if the current user is not the message sender
          for (var doc in messageCollection.docs) {
            await doc.reference.update({
              'receiverName': userProfileEntity.username,
            });
          }
        }
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> isMessageSender() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("conversation")
        .doc()
        .collection("message")
        .where('senderId', isEqualTo: currentUser)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isCurrentSender() async {
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
