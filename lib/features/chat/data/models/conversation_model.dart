import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.receiverId,
    required super.receiverName,
    required super.receiverNickname,
    required super.receiverPhotoUrl,
    required super.senderId,
    required super.senderName,
    required super.senderNickname,
    required super.senderPhotoUrl,
    required super.lastMessage,
    required super.lastMessageSenderName,
    required super.lastMessageSenderId,
    required super.lastMessageTime,
    required super.isSeen,
    required super.unSeenMessages,
    required super.senderToken,
    required super.receiverToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverNickname": receiverNickname,
      "receiverPhotoUrl": receiverPhotoUrl,
      "senderId": senderId,
      "senderName": senderName,
      "senderNickname": senderNickname,
      "senderPhotoUrl": senderPhotoUrl,
      "lastMessage": lastMessage,
      "lastMessageSenderName": lastMessageSenderName,
      "lastMessageSenderId": lastMessageSenderId,
      "lastMessageTime": lastMessageTime,
      "isSeen": isSeen,
      "unSeenMessages": unSeenMessages,
      "senderToken": senderToken,
      "receiverToken": receiverToken,
    };
  }

  factory ConversationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ConversationModel(
      receiverId: snapshot['receiverId'],
      receiverName: snapshot['receiverName'],
      receiverNickname: snapshot['receiverNickname'],
      receiverPhotoUrl: snapshot['receiverPhotoUrl'],
      senderId: snapshot['senderId'],
      senderName: snapshot['senderName'],
      senderNickname: snapshot['senderNickname'],
      senderPhotoUrl: snapshot['senderPhotoUrl'],
      lastMessage: snapshot['lastMessage'],
      lastMessageSenderName: snapshot['lastMessageSenderName'],
      lastMessageSenderId: snapshot['lastMessageSenderId'],
      lastMessageTime: snapshot['lastMessageTime'],
      isSeen: snapshot['isSeen'],
      unSeenMessages: snapshot['unSeenMessages'],
      senderToken: snapshot["senderToken"],
      receiverToken: snapshot["receiverToken"],
    );
  }
}
