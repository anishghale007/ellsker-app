import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.receiverUserId,
    required super.receiverToken,
    required super.title,
    required super.body,
    required super.receiverPhotoUrl,
    required super.receiverUsername,
    required super.notificationType,
    required super.senderPhotoUrl,
    required super.senderToken,
    required super.senderUserId,
    required super.senderUsername,
  });
}
