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
    required String receiverUserId,
    required String receiverToken,
    required String receiverPhotoUrl,
    required String receiverUsername,
    required String senderUserId,
    required String senderPhotoUrl,
    required String senderUsername,
    required String senderToken,
    required BuildContext context,
  }) async {
    if (receivedAction.buttonKeyPressed == "ACCEPT") {
      final currentUser = FirebaseAuth.instance.currentUser!;
      context.read<CallBloc>().add(PickupCallEvent(userId: senderUserId));
      // IF THE CALL IS ACCEPTED
      context.router.push(
        VideoCallRoute(
          callerId: senderUserId, // from notification
          callerName: senderUsername,
          callerPhotoUrl: senderPhotoUrl,
          receiverId: currentUser.uid,
          callStartTime: DateTime.now().toString(),
        ),
      );
    } else if (receivedAction.buttonKeyPressed == "REJECT") {
      // IF THE CALL IS REJECTED
      // Send did not pickup notification
      final currentUser = FirebaseAuth.instance.currentUser!;
      context.read<NotificationCubit>().sendNotification(
            notificationEntity: NotificationEntity(
              receiverUserId: senderUserId, // other user's id
              receiverToken: senderToken,
              receiverPhotoUrl: senderPhotoUrl,
              receiverUsername: senderUsername,
              senderUserId: receiverUserId,
              senderToken: receiverToken,
              senderPhotoUrl: receiverPhotoUrl,
              senderUsername: receiverUsername,
              title: currentUser.displayName!,
              body: Constant.didNotPickUpMessageContent,
              notificationType: Constant.missedCallNotification,
            ),
          );
      // End Call Event (Did Not Pickup Call)
      context.read<CallBloc>().add(
            EndCallEvent(
              callerId: senderUserId, // other user
              callerPhotoUrl: senderPhotoUrl,
              callerName: senderUsername,
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
        userId: senderUserId,
        username: senderUsername,
        photoUrl: senderPhotoUrl,
        receiverToken: senderToken,
        senderToken: receiverToken, // Token of the user who rejects the call
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
  required String receiverToken,
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
            receiverNickname: username,
            receiverPhotoUrl: photoUrl,
            senderId: currentUser.uid, // me
            senderName: currentUser.displayName!,
            senderNickname: currentUser.displayName!,
            senderPhotoUrl: currentUser.photoURL!,
            lastMessage: messageContent,
            lastMessageTime: DateTime.now().toString(),
            lastMessageSenderName: currentUser.displayName!,
            lastMessageSenderId: currentUser.uid,
            isSeen: false,
            unSeenMessages: 0,
            receiverToken: receiverToken,
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
