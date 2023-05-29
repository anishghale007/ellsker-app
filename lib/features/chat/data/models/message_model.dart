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
    super.latitude,
    super.longitude,
    super.fileUrl,
    super.photoFile,
    super.audioFile,
    super.gifUrl,
    super.messageId,
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
      messageType: (snapshot['messageType']).toEnum(),
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
      fileUrl: snapshot['fileUrl'],
      gifUrl: snapshot['gifUrl'],
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
      "fileUrl": fileUrl,
      "gifUrl": gifUrl,
      "messageType": messageType.type,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
