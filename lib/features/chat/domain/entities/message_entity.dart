import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class MessageEntity extends Equatable {
  final String messageContent;
  final String messageTime;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String messageType;
  final String? latitude;
  final String? longitude;
  final String? photoUrl;
  final XFile? image;

  const MessageEntity({
    required this.messageContent,
    required this.messageTime,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.messageType,
    this.latitude,
    this.longitude,
    this.photoUrl,
    this.image,
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
        messageType,
        latitude,
        longitude,
        photoUrl,
        image,
      ];
}
