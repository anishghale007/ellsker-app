import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/chat/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/domain/repositories/firebase_repository.dart';

class SendNotificationUseCase implements UseCase<String, Params> {
  final FirebaseRepository firebaseRepository;

  const SendNotificationUseCase({required this.firebaseRepository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await firebaseRepository.sendNotification(params.notificationEntity);
  }
}

class Params extends Equatable {
  final NotificationEntity notificationEntity;

  const Params({required this.notificationEntity});

  @override
  List<Object?> get props => [notificationEntity];
}
