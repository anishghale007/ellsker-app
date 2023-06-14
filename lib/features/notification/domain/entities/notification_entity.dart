import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String conversationId;
  final String token;
  final String title;
  final String body;
  final String photoUrl;
  final String username;
  final String notificationType;

  const NotificationEntity({
    required this.conversationId,
    required this.token,
    required this.title,
    required this.body,
    required this.photoUrl,
    required this.username,
    required this.notificationType,
  });

  @override
  List<Object?> get props => [
        token,
        title,
        body,
        photoUrl,
        username,
        notificationType,
      ];
}
