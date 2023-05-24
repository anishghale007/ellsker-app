import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship_practice/features/profile/data/models/user_profile_model.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Stream<UserProfileEntity> getCurrentUser();
  Future<String> editProfile(UserProfileEntity userProfileEntity);
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
      if (userProfileEntity.image != null) {
        /* 
        ////// IF THE USER UPLOADS A NEW PROFILE PICTURE
         */

        final newPhotoUrl = await _storeImageToFirebase(
          file: File(userProfileEntity.image!.path),
          email: userProfileEntity.email,
        );

        _saveNewUserDataToCollection(
          username: userProfileEntity.username,
          email: userProfileEntity.email,
          age: userProfileEntity.age,
          instagram: userProfileEntity.instagram,
          location: userProfileEntity.location,
          newPhotoUrl: newPhotoUrl,
        );
      } else {
        /* 
        ///// IF THE USER DOES NOT UPLOAD A NEW PROFILE PICTURE
         */
        final currentProfile = FirebaseAuth.instance.currentUser!.photoURL;
        _saveNewUserDataToCollection(
          username: userProfileEntity.username,
          email: userProfileEntity.email,
          age: userProfileEntity.age,
          instagram: userProfileEntity.instagram,
          location: userProfileEntity.location,
          newPhotoUrl: currentProfile!,
        );
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  void _saveNewUserDataToCollection({
    required String username,
    required String email,
    required String age,
    required String instagram,
    required String location,
    required String newPhotoUrl,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    var currentUserConversationCollection =
        await dbUser.doc(currentUser.uid).collection('conversation').get();
    var notCurrentUserCollection =
        await dbUser.where('userId', isNotEqualTo: currentUser.uid).get();

    // UPDATE THE CURRENT USER COLLECTION
    await currentUser.updateDisplayName(username);
    await currentUser.updatePhotoURL(newPhotoUrl);
    await dbUser.doc(currentUser.uid).update({
      'username': username,
      'age': age,
      'instagram': instagram,
      'location': location,
      'photoUrl': newPhotoUrl,
    });

    // UPDATING THE CONVERSATION COLLECTION OF THE CURRENT USER
    for (var doc in currentUserConversationCollection.docs) {
      await doc.reference.update({
        'senderName': username,
        'senderPhotoUrl': newPhotoUrl,
      });
    }

    // UPDATING THE CONVERSATION COLLECTION OF THE OTHER USER
    for (var doc in notCurrentUserCollection.docs) {
      var conversationCollection =
          await doc.reference.collection('conversation').get();
      for (var doc in conversationCollection.docs) {
        await doc.reference.update({
          'receiverName': username,
          'receiverPhotoUrl': newPhotoUrl,
        });
      }
    }

    // UPDATING THE MESSAGE COLLECTION OF THE CURRENT USER

    // if the sender is the current user
    for (var doc in currentUserConversationCollection.docs) {
      var messageCollection = await doc.reference
          .collection('message')
          .where('senderId', isEqualTo: currentUser.uid)
          .get();
      for (var doc in messageCollection.docs) {
        await doc.reference.update({
          'senderName': username,
          'senderPhotoUrl': newPhotoUrl,
        });
      }
    }

    // if the sender is not the current user
    for (var doc in currentUserConversationCollection.docs) {
      var messageCollection = await doc.reference
          .collection('message')
          .where('senderId', isNotEqualTo: currentUser.uid)
          .get();
      for (var doc in messageCollection.docs) {
        await doc.reference.update({
          'receiverName': username,
          'receiverPhotoUrl': newPhotoUrl,
        });
      }
    }

    // UPDATING THE MESSAGE COLLECTION OF THE OTHER USER

    // if the sender is the current user
    for (var doc in notCurrentUserCollection.docs) {
      var conversationCollection =
          await doc.reference.collection('conversation').get();
      for (var doc in conversationCollection.docs) {
        var messageCollection = await doc.reference
            .collection('message')
            .where('senderId', isEqualTo: currentUser.uid)
            .get();
        for (var doc in messageCollection.docs) {
          await doc.reference.update({
            'senderName': username,
            'senderPhotoUrl': newPhotoUrl,
          });
        }
      }
    }

    // if the sender is not the current user
    for (var doc in notCurrentUserCollection.docs) {
      var conversationCollection =
          await doc.reference.collection('conversation').get();
      for (var doc in conversationCollection.docs) {
        var messageCollection = await doc.reference
            .collection('message')
            .where('senderId', isNotEqualTo: currentUser.uid)
            .get();
        for (var doc in messageCollection.docs) {
          await doc.reference.update({
            'receiverName': username,
            'receiverPhotoUrl': newPhotoUrl,
          });
        }
      }
    }
  }

  Future<String> _storeImageToFirebase({
    required File file,
    required String email,
  }) async {
    final newImageId = "$email:UploadedAt:${DateTime.now().toString()}";
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('$email\'s profile/$newImageId')
        .putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String newPhotoUrl = await snapshot.ref.getDownloadURL();
    return newPhotoUrl;
  }
}
