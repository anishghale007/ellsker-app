import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUserEntity extends Equatable {
  final UserCredential userCredential;

  const AuthUserEntity({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}
