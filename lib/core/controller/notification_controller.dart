import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/routes/router.gr.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction, {
    required String userId,
    required String token,
    required String photoUrl,
    required String username,
    required BuildContext context,
  }) async {
    if (receivedAction.buttonKeyPressed == "ACCEPT") {
      // If the call is accepted
      context.router.push(const VideoCallRoute());
      context.read<CallBloc>().add(PickupCallEvent(userId: userId));
    } else if (receivedAction.buttonKeyPressed == "REJECT") {
      // If the call is rejected
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
    }
  }
}
