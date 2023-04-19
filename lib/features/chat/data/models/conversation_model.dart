import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.receiverId,
    required super.receiverName,
    required super.receiverPhotoUrl,
    required super.senderId,
    required super.senderName,
    required super.senderPhotoUrl,
    required super.lastMessage,
    required super.lastMessageSenderName,
    required super.lastMessageTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverPhotoUrl": receiverPhotoUrl,
      "senderId": senderId,
      "senderName": senderName,
      "senderPhotoUrl": senderPhotoUrl,
      "lastMessage": lastMessage,
      "lastMessageSenderName": lastMessageSenderName,
      "lastMessageTime": lastMessageTime,
    };
  }

  factory ConversationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ConversationModel(
      receiverId: snapshot['receiverId'],
      receiverName: snapshot['receiverName'],
      receiverPhotoUrl: snapshot['receiverPhotoUrl'],
      senderId: snapshot['senderId'],
      senderName: snapshot['senderName'],
      senderPhotoUrl: snapshot['senderPhotoUrl'],
      lastMessage: snapshot['lastMessage'],
      lastMessageSenderName: snapshot['lastMessageSenderName'],
      lastMessageTime: snapshot['lastMessageTime'],
    );
  }
}
