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
      final currentUser = FirebaseAuth.instance.currentUser;
      var currentUserConversationCollection =
          await dbUser.doc(currentUser!.uid).collection('conversation').get();
      var notCurrentUserCollection =
          await dbUser.where('userId', isNotEqualTo: currentUser.uid).get();
      if (userProfileEntity.image != null) {
        /* 
        ////// IF THE USER UPLOADS A NEW PROFILE PICTURE
         */

        final newImageId =
            "${userProfileEntity.email}:UploadedAt:${DateTime.now().toString()}";
        final newImageStorage = FirebaseStorage.instance
            .ref()
            .child('${userProfileEntity.email}/$newImageId');
        final newImageFile = File(userProfileEntity.image!.path);
        await newImageStorage.putFile(newImageFile);
        final newPhotoUrl = await newImageStorage.getDownloadURL();

        // UPDATE THE CURRENT USER COLLECTION
        await currentUser.updateDisplayName(userProfileEntity.username);
        await currentUser.updatePhotoURL(newPhotoUrl);
        await dbUser.doc(currentUser.uid).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
          'photoUrl': newPhotoUrl,
        });

        // UPDATING THE CONVERSATION COLLECTION OF THE CURRENT USER
        for (var doc in currentUserConversationCollection.docs) {
          await doc.reference.update({
            'senderName': userProfileEntity.username,
            'senderPhotoUrl': newPhotoUrl,
          });
        }

        // UPDATING THE CONVERSATION COLLECTION OF THE OTHER USER
        for (var doc in notCurrentUserCollection.docs) {
          var conversationCollection =
              await doc.reference.collection('conversation').get();
          for (var doc in conversationCollection.docs) {
            await doc.reference.update({
              'receiverName': userProfileEntity.username,
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
              'senderName': userProfileEntity.username,
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
              'receiverName': userProfileEntity.username,
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
                'senderName': userProfileEntity.username,
                'senderPhotoUrl': newPhotoUrl,
              });
            }
          }
        }

        // if the sender is not the current user#
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
                'receiverName': userProfileEntity.username,
                'receiverPhotoUrl': newPhotoUrl,
              });
            }
          }
        }
      } else {
        /* 
        ///// IF THE USER DOES NOT UPLOAD A NEW PROFILE PICTURE
         */

        // UPDATING THE CURRENT USER COLLECTION
        await currentUser.updateDisplayName(userProfileEntity.username);
        await dbUser.doc(currentUser.uid).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
        });

        // UPDATING THE CONVERSATION COLLECTION OF THE CURRENT USER
        for (var doc in currentUserConversationCollection.docs) {
          await doc.reference.update({
            'senderName': userProfileEntity.username,
          });
        }

        // UPDATING THE CONVERSATION COLLECTION OF THE OTHER USER
        for (var doc in notCurrentUserCollection.docs) {
          var conversationCollection =
              await doc.reference.collection('conversation').get();
          for (var doc in conversationCollection.docs) {
            await doc.reference.update({
              'receiverName': userProfileEntity.username,
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
              'senderName': userProfileEntity.username,
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
              'receiverName': userProfileEntity.username,
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
                'senderName': userProfileEntity.username,
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
                'receiverName': userProfileEntity.username,
              });
            }
          }
        }
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
