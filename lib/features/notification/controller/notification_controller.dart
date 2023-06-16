import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/routes/router.gr.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction, {
    required String userId,
    required String token,
    required String senderToken,
    required String photoUrl,
    required String username,
    required BuildContext context,
  }) async {
    if (receivedAction.buttonKeyPressed == "ACCEPT") {
      final currentUser = FirebaseAuth.instance.currentUser!;
      // IF THE CALL IS ACCEPTED
      context.router.push(
        VideoCallRoute(
          callerId: userId, // from notification
          callerName: username,
          callerPhotoUrl: photoUrl,
          receiverId: currentUser.uid,
          callStartTime: DateTime.now().toString(),
        ),
      );
      context.read<CallBloc>().add(PickupCallEvent(userId: userId));
    } else if (receivedAction.buttonKeyPressed == "REJECT") {
      // IF THE CALL IS REJECTED
      // Send did not pickup notification
      final currentUser = FirebaseAuth.instance.currentUser!;
      context.read<NotificationCubit>().sendNotification(
            notificationEntity: NotificationEntity(
              conversationId: userId, // other user's id
              token: token,
              title: currentUser.displayName!,
              body: Constant.didNotPickUpMessageContent,
              photoUrl: photoUrl,
              username: username,
              notificationType: Constant.missedCallNotification,
            ),
          );
      // End Call Event (Did Not Pickup Call)
      context.read<CallBloc>().add(
            EndCallEvent(
              callerId: userId, // other user
              callerPhotoUrl: photoUrl,
              callerName: username,
              receiverId: currentUser.uid,
              callStartTime: DateTime.now().toString(),
              callEndTime: DateTime.now().toString(),
              didPickup: false,
            ),
          );
      // Send Did Not Pickup Call Message
      _sendMessage(
        context,
        currentUser,
        userId: userId,
        username: username,
        photoUrl: photoUrl,
        token: token,
        senderToken: senderToken,
        messageContent: Constant.didNotPickUpMessageContent,
        messageType: MessageType.call,
      );
    }
  }
}

void _sendMessage(
  BuildContext context,
  User currentUser, {
  required String userId,
  required String username,
  required String photoUrl,
  required String token,
  required String senderToken,
  required dynamic messageContent,
  required MessageType messageType,
  XFile? photoFile,
  XFile? videoFile,
  File? audioFile,
  String? gifUrl,
  String? latitude,
  String? longitude,
}) {
  context.read<ConversationBloc>().add(
        CreateConversationEvent(
          conversationEntity: ConversationEntity(
            receiverId: userId,
            receiverName: username,
            receiverPhotoUrl: photoUrl,
            senderId: currentUser.uid, // me
            senderName: currentUser.displayName!,
            senderPhotoUrl: currentUser.photoURL!,
            lastMessage: messageContent,
            lastMessageTime: DateTime.now().toString(),
            lastMessageSenderName: currentUser.displayName!,
            lastMessageSenderId: currentUser.uid,
            isSeen: false,
            unSeenMessages: 0,
            receiverToken: token,
            senderToken: senderToken,
          ),
        ),
      );
  context.read<MessageCubit>().sendMessage(
        messageEntity: MessageEntity(
          messageContent: messageContent,
          messageTime: DateTime.now().toString(),
          senderId: currentUser.uid,
          senderName: currentUser.displayName!,
          senderPhotoUrl: currentUser.photoURL!,
          receiverId: userId,
          receiverName: username,
          receiverPhotoUrl: photoUrl,
          messageType: messageType,
          photoFile: photoFile,
          videoFile: videoFile,
          audioFile: audioFile,
          latitude: latitude,
          longitude: longitude,
          gifUrl: gifUrl,
        ),
      );
}
