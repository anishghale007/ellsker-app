import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleUserEntity extends Equatable {
  final UserCredential userCredential;

  const GoogleUserEntity({required this.userCredential});

  @override
  List<Object?> get props => [userCredential];
}
