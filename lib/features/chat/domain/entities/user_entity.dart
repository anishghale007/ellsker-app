import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userName;
  final String photoUrl;

  const UserEntity({
    required this.userId,
    required this.userName,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        photoUrl,
      ];
}
