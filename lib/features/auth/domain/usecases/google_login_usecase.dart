import 'package:internship_practice/features/auth/domain/repositories/firebase_repository.dart';

class GooogleLoginUseCase {
  final FirebaseRepository repository;

  GooogleLoginUseCase({required this.repository});

  Future<void> call() async {
    return await repository.googleSignIn();
  }
}
