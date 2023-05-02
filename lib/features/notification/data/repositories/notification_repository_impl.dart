import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:internship_practice/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;

  const NotificationRepositoryImpl(
      {required this.notificationRemoteDataSource});

  @override
  Future<Either<Failure, String>> sendNotification(
      NotificationEntity notificationEntity) async {
    try {
      final response = await notificationRemoteDataSource
          .sendNotification(notificationEntity);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
