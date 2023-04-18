import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageContent;
  final String messageTime;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;

  const MessageEntity({
    required this.messageContent,
    required this.messageTime,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
  });

  @override
  List<Object?> get props => [
        messageContent,
        messageTime,
        senderId,
        senderName,
        senderPhotoUrl,
        receiverId,
        receiverName,
        receiverPhotoUrl,
      ];
}
