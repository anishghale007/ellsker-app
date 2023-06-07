import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.username,
    required super.age,
    required super.instagram,
    required super.location,
    required super.email,
    super.image,
  });

  factory UserProfileModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserProfileModel(
      username: snapshot['username'],
      email: snapshot['email'],
      age: snapshot['age'],
      instagram: snapshot['instagram'],
      location: snapshot['location'],
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'],
      email: json['email'],
      age: json['age'],
      instagram: json['instagram'],
      location: json['location'],
    );
  }
}
