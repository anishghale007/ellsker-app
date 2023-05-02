import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/core/usecases/usecase.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/domain/repositories/notification_repository.dart';

class SendNotificationUseCase implements UseCase<String, Params> {
  final NotificationRepository notificationRepository;

  const SendNotificationUseCase({required this.notificationRepository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await notificationRepository
        .sendNotification(params.notificationEntity);
  }
}

class Params extends Equatable {
  final NotificationEntity notificationEntity;

  const Params({required this.notificationEntity});

  @override
  List<Object?> get props => [notificationEntity];
}
