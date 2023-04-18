import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;

  const ConversationEntity({
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
  });

  @override
  List<Object?> get props => [
        receiverId,
        receiverName,
        senderId,
        senderName,
        senderPhotoUrl,
        receiverPhotoUrl,
      ];
}
