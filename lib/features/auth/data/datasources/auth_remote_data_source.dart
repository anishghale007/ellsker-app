import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internship_practice/features/auth/data/models/auth_user_model.dart';
import 'package:internship_practice/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> googleSignIn();
  Future<AuthUserModel> facebookSignIn();
  Future<void> signOut();
  Future<void> setUserStatus(bool isOnline);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Future<AuthUserModel> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final userInfo =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      var id = userInfo!.uid;
      final String? token = await FirebaseMessaging.instance.getToken();
      if (await isExistentUser(id)) {
        log("User already exists");
        if (await isNotSameToken(token!)) {
          log("New token detected in an already existing user. Updating the token.");
          _saveNewTokenToCollection(
            uid: userInfo.uid,
            token: token,
          );
        } else {
          log("Same token");
        }
      } else {
        _saveDataToUserCollection(
          userInfo,
          token: token!,
        );
      }
      return AuthUserModel(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<AuthUserModel> facebookSignIn() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      final userInfo = (await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential))
          .user;
      var id = userInfo!.uid;
      final String? token = await FirebaseMessaging.instance.getToken();
      if (await isExistentUser(id)) {
        log("User already exists");
        if (await isNotSameToken(token!)) {
          log("New token detected in an already existing user");
          _saveNewTokenToCollection(
            uid: userInfo.uid,
            token: token,
          );
        } else {
          log("Same token");
        }
      } else {
        _saveDataToUserCollection(
          userInfo,
          token: token!,
        );
      }
      return AuthUserModel(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      GoogleSignIn googleSignIn = GoogleSignIn();
      FacebookAuth facebookAuth = FacebookAuth.instance;
      await FirebaseAuth.instance.signOut();
      await facebookAuth.logOut();
      await googleSignIn.signOut();
      dbUser.doc(currentUser.uid).update({
        "isOnline": false,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isExistentUser(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isNotSameToken(String token) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('token', isNotEqualTo: token)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  void _saveDataToUserCollection(
    User userInfo, {
    required String token,
  }) async {
    final userData = UserModel(
      userId: userInfo.uid,
      email: userInfo.email!,
      photoUrl: userInfo.photoURL!,
      userName: userInfo.displayName!,
      token: token,
      age: "18",
      instagram: "@instagram",
      location: "Location",
      isOnline: true,
      inCall: false,
    ).toJson();
    dbUser.doc(userInfo.uid).set(userData);
  }

  void _saveNewTokenToCollection({
    required String uid,
    required String token,
  }) async {
    log("New token detected in an already existing user. Updating the token.");
    // Updating the user collection of the current user
    dbUser.doc(uid).update({
      "token": token,
    });
    // Updating the conversation collection of the current user
    var currentUserConversationCollection =
        await dbUser.doc(uid).collection('conversation').get();
    for (var doc in currentUserConversationCollection.docs) {
      await doc.reference.update({
        "senderToken": token,
      });
    }
    // Updating the conversation collection of the other user
    var notCurrentUserCollection =
        await dbUser.where('userId', isNotEqualTo: uid).get();
    for (var doc in notCurrentUserCollection.docs) {
      var conversationCollection =
          await doc.reference.collection('conversation').get();
      for (var doc in conversationCollection.docs) {
        await doc.reference.update({
          "receiverToken": token,
        });
      }
    }
  }

  @override
  Future<void> setUserStatus(bool isOnline) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      await dbUser.doc(currentUser.uid).update({
        "isOnline": isOnline,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
