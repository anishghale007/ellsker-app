import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.conversationId,
    required super.token,
    required super.title,
    required super.body,
    required super.photoUrl,
    required super.username,
  });
}
