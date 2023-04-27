import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.userName,
    required super.photoUrl,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['username'],
      photoUrl: json['photoUrl'],
      token: json['token'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      userId: snapshot.get('userId'),
      userName: snapshot.get('username'),
      photoUrl: snapshot.get('photoUrl'),
      token: snapshot.get('token'),
    );
  }
}
