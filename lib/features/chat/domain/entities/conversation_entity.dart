import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String lastMessage;
  final String lastMessageSenderName;
  final String lastMessageTime;
  final bool isSeen;
  final int unSeenMessages;

  const ConversationEntity({
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.lastMessage,
    required this.lastMessageSenderName,
    required this.lastMessageTime,
    required this.isSeen,
    required this.unSeenMessages,
  });

  @override
  List<Object?> get props => [
        receiverId,
        receiverName,
        senderId,
        senderName,
        senderPhotoUrl,
        receiverPhotoUrl,
        lastMessage,
        lastMessageSenderName,
        lastMessageTime,
        isSeen,
        unSeenMessages,
      ];
}
