import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Stream<List<UserEntity>> getAllUsers();
}
