import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userName;
  final String email;
  final String photoUrl;
  final String token;
  final bool isOnline;

  const UserEntity({
    required this.userId,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.token,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        email,
        photoUrl,
        token,
        isOnline,
      ];
}
