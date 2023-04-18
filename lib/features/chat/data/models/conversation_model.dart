import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.receiverId,
    required super.receiverName,
    required super.receiverPhotoUrl,
    required super.senderId,
    required super.senderName,
    required super.senderPhotoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverPhotoUrl": receiverPhotoUrl,
      "senderId": senderId,
      "senderName": senderName,
      "senderPhotoUrl": senderPhotoUrl,
    };
  }
}
