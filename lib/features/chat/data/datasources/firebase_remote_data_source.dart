import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/data/models/user_model.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Stream<List<UserEntity>> getAllUsers();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return dbUser.snapshots().map(
        (event) => event.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}
