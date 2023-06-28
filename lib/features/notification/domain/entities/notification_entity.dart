import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String title;
  final String body;
  final String receiverUserId;
  final String receiverToken;
  final String receiverPhotoUrl;
  final String receiverUsername;
  final String senderUserId;
  final String senderToken;
  final String senderPhotoUrl;
  final String senderUsername;
  final String notificationType;

  const NotificationEntity({
    required this.receiverUserId,
    required this.receiverToken,
    required this.title,
    required this.body,
    required this.receiverPhotoUrl,
    required this.receiverUsername,
    required this.notificationType,
    required this.senderPhotoUrl,
    required this.senderToken,
    required this.senderUserId,
    required this.senderUsername,
  });

  @override
  List<Object?> get props => [
        receiverToken,
        title,
        body,
        receiverPhotoUrl,
        receiverUsername,
        notificationType,
        senderPhotoUrl,
        senderToken,
        senderUserId,
        senderUsername,
      ];
}
