import 'package:internship_practice/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  const SignOutUseCase({required this.authRepository});

  Future<void> call() async {
    return await authRepository.signOut();
  }
}
