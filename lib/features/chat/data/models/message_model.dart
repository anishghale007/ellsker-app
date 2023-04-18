import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.messageContent,
    required super.messageTime,
    required super.senderId,
    required super.senderName,
    required super.senderPhotoUrl,
    required super.receiverId,
    required super.receiverName,
    required super.receiverPhotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "messageContent": messageContent,
      "messageTime": messageTime,
      "senderId": senderId,
      "senderName": senderName,
      "senderPhotoUrl": senderPhotoUrl,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverPhotoUrl": receiverPhotoUrl,
    };
  }
}
