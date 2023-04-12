import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookUserEntity extends Equatable {
  final UserCredential userCredential;

  const FacebookUserEntity({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}
