import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/core/functions/app_dialogs.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/audio_message_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/gif_message_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/location_message_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/photo_message_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/text_message_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/video_player_widget.dart';
import 'package:internship_practice/routes/router.gr.dart';

class ChatBoxWidget extends StatelessWidget {
  final String messageId;
  final String messageContent;
  final String messageTime;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final MessageType messageType;
  final String fileUrl;
  final String gifUrl;
  final String latitude;
  final String longitude;

  const ChatBoxWidget({
    Key? key,
    required this.messageId,
    required this.messageContent,
    required this.messageTime,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.messageType,
    required this.fileUrl,
    required this.gifUrl,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (messageType) {
      case MessageType.photo:
        return PhotoMessageWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          fileUrl: fileUrl,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: false,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
        );
      case MessageType.location:
        return LocationMessageWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          latitude: latitude,
          longitude: longitude,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: false,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
          onTap: () {
            context.router.push(
              MapRoute(
                userLatitude: double.parse(latitude),
                userLongitude: double.parse(longitude),
                username: senderName,
              ),
            );
          },
        );
      case MessageType.gif:
        return GifMessageWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          gifUrl: gifUrl,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: false,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
        );
      case MessageType.video:
        return VideoPlayerWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          videoUrl: fileUrl,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: false,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
        );
      case MessageType.audio:
        return AudioMessageWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          audioUrl: fileUrl,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: false,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
        );
      // return VoiceMessageWidget(
      //   senderId: senderId,
      //   senderName: senderName,
      //   senderPhotoUrl: senderPhotoUrl,
      //   audioUrl: fileUrl,
      //   messageTime: messageTime,
      //   onSenderLongPress: () {
      //     _showDialog(
      //       context,
      //       canCopy: false,
      //       canUnsend: true,
      //     );
      //   },
      // );
      default:
        return TextMessageWidget(
          senderId: senderId,
          senderName: senderName,
          senderPhotoUrl: senderPhotoUrl,
          messageContent: messageContent,
          messageTime: messageTime,
          onSenderLongPress: () {
            _showDialog(
              context,
              canCopy: true,
              canUnsend: true,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
          onReceiverLongPress: () {
            _showDialog(
              context,
              canCopy: true,
              canUnsend: false,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
          },
        );
    }
  }

  void _showDialog(
    BuildContext context, {
    required bool canCopy,
    required bool canUnsend,
    required MessageType messageType,
    required String receiverId,
    required String senderId,
  }) {
    AppDialogs.showSimpleDialog(
      context: context,
      title: const Text("Choose an action", textAlign: TextAlign.center),
      canCopy: canCopy,
      canUnsend: canUnsend,
      onCopy: () {
        Clipboard.setData(ClipboardData(text: messageContent));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Text copied to keyboard"),
            duration: Duration(seconds: 5),
          ),
        );
      },
      onUnsend: () {
        context.read<MessageCubit>().unsendMessage(
              conversationId: receiverId,
              messageId: messageId,
              messageType: messageType,
              receiverId: receiverId,
              senderId: senderId,
            );
        Navigator.of(context).pop();
      },
    );
  }
}
