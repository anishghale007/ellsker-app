import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internship_practice/features/auth/data/models/facebook_user_model.dart';
import 'package:internship_practice/features/auth/data/models/google_user_model.dart';

abstract class FirebaseRemoteDataSource {
  Future<GoogleUserModel> googleSignIn();
  Future<FacebookUserModel> facebookSignIn();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Future<GoogleUserModel> googleSignIn() async {
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
    await dbUser.add({
      'userId': userInfo!.uid,
      'userName': userInfo.displayName,
      'email': userInfo.email,
      'photoUrl': userInfo.photoURL,
    });
    return GoogleUserModel(userCredential: userCredential);
  }

  @override
  Future<FacebookUserModel> facebookSignIn() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    return FacebookUserModel(userCredential: userCredential);
  }
}
