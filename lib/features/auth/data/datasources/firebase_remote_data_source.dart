import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internship_practice/features/auth/data/models/google_user_model.dart';

abstract class FirebaseRemoteDataSource {
  Future<GoogleUserModel> googleSignIn();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
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
    return GoogleUserModel(userCredential: userCredential);
  }
}
