import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileEntity extends Equatable {
  final String username;
  final String email;
  final String age;
  final String instagram;
  final String location;
  final XFile? image;

  const UserProfileEntity({
    required this.username,
    required this.email,
    required this.age,
    required this.instagram,
    required this.location,
    this.image,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        age,
        instagram,
        location,
        image,
      ];
}
