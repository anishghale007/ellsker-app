import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internship_practice/features/auth/data/models/facebook_user_model.dart';
import 'package:internship_practice/features/auth/data/models/google_user_model.dart';
import 'package:internship_practice/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<GoogleUserModel> googleSignIn();
  Future<FacebookUserModel> facebookSignIn();
  Future<void> signOut();
  Future<bool> isExistentUser(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Future<GoogleUserModel> googleSignIn() async {
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
      if (await isExistentUser(id)) {
        log("User already exists");
      } else {
        final userData = UserModel(
          userId: userInfo.uid,
          email: userInfo.email!,
          photoUrl: userInfo.photoURL!,
          userName: userInfo.displayName!,
        ).toJson();
        dbUser.doc(userInfo.uid).set(userData);
      }
      return GoogleUserModel(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<FacebookUserModel> facebookSignIn() async {
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
      if (await isExistentUser(id)) {
        log("User already exists");
      } else {
        final userData = UserModel(
          userId: userInfo.uid,
          email: userInfo.email!,
          photoUrl: userInfo.photoURL!,
          userName: userInfo.displayName!,
        ).toJson();
        dbUser.doc(userInfo.uid).set(userData);
      }
      return FacebookUserModel(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> isExistentUser(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
