import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userName;
  final String photoUrl;
  final String token;

  const UserEntity({
    required this.userId,
    required this.userName,
    required this.photoUrl,
    required this.token,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        photoUrl,
        token,
      ];
}
