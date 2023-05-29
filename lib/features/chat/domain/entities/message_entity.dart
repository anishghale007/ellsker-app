import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';

class MessageEntity extends Equatable {
  final String? messageId;
  final String messageContent;
  final String messageTime;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final MessageType messageType;
  final String? latitude;
  final String? longitude;
  final String? fileUrl;
  final String? gifUrl;
  final XFile? photoFile;
  final XFile? videoFile;
  final File? audioFile;

  const MessageEntity({
    this.messageId,
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
    this.fileUrl,
    this.photoFile,
    this.videoFile,
    this.audioFile,
    this.gifUrl,
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
        fileUrl,
        photoFile,
        videoFile,
        audioFile,
        gifUrl,
      ];
}
