import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.userName,
    required super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      photoUrl: json['photoUrl'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      userId: snapshot.get('userId'),
      userName: snapshot.get('userName'),
      photoUrl: snapshot.get('photoUrl'),
    );
  }
}
