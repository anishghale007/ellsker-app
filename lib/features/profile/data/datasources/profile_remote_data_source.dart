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
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      if (userProfileEntity.image != null) {
        // If the user uploads a new profile picture
        // final oldImageStorage = FirebaseStorage.instance
        //     .ref()
        //     .child('userProfile/${userProfileEntity.email}');
        // await oldImageStorage.delete();
        final newImageId =
            "${userProfileEntity.email}uploadedAt:${DateTime.now().toString()}";
        final newImageStorage = FirebaseStorage.instance
            .ref()
            .child('${userProfileEntity.email}/$newImageId');
        final newImageFile = File(userProfileEntity.image!.path);
        await newImageStorage.putFile(newImageFile);
        final newPhotoUrl = await newImageStorage.getDownloadURL();
        await dbUser.doc(currentUser).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
          'photoUrl': newPhotoUrl,
        });
      } else {
        // if the user does not upload a new profile picture
        await dbUser.doc(currentUser).update({
          'username': userProfileEntity.username,
          'age': userProfileEntity.age,
          'instagram': userProfileEntity.instagram,
          'location': userProfileEntity.location,
        });
      }
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
