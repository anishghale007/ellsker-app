import 'package:cloud_firestore/cloud_firestore.dart';
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
    required super.messageType,
    super.photoUrl,
    super.image,
  });

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MessageModel(
      messageContent: snapshot['messageContent'],
      messageTime: snapshot['messageTime'],
      senderId: snapshot['senderId'],
      senderName: snapshot['senderName'],
      senderPhotoUrl: snapshot['senderPhotoUrl'],
      receiverId: snapshot['receiverId'],
      receiverName: snapshot['receiverName'],
      receiverPhotoUrl: snapshot['receiverPhotoUrl'],
      messageType: snapshot['messageType'],
      photoUrl: snapshot['photoUrl'],
    );
  }

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
      "photoUrl": photoUrl,
      "messageType": messageType,
    };
  }
}
