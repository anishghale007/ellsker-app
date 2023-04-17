import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class GetAllUsersUsecase {
  final FirebaseRepository firebaseRepository;

  const GetAllUsersUsecase({required this.firebaseRepository});

  Stream<List<UserEntity>> call() {
    return firebaseRepository.getAllUsers();
  }
}
