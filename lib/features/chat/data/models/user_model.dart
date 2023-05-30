import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.userName,
    required super.email,
    required super.photoUrl,
    required super.token,
    required super.isOnline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['username'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      token: json['token'],
      isOnline: json['isOnline'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      userId: snapshot.get('userId'),
      userName: snapshot.get('username'),
      email: snapshot.get('email'),
      photoUrl: snapshot.get('photoUrl'),
      token: snapshot.get('token'),
      isOnline: snapshot.get('isOnline'),
    );
  }
}
