import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/auth/data/models/user_model.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/call/presentation/widgets/busy_call_widget.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/routes/router.gr.dart';

class CallCheckScreen extends StatelessWidget implements AutoRouteWrapper {
  final String userId;
  final String photoUrl;
  final String username;
  final String token;
  final String senderToken;

  const CallCheckScreen({
    super.key,
    required this.userId,
    required this.photoUrl,
    required this.username,
    required this.token,
    required this.senderToken,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          // var data = snapshot.data!.data();
          UserModel user =
              UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else {
            if (user.isOnline == false) {
              return BusyCallWidget(
                photoUrl: photoUrl,
                username: username,
                isOffline: true,
              );
            } else if (user.inCall == true) {
              return BusyCallWidget(
                photoUrl: photoUrl,
                username: username,
                isOffline: false,
              );
            } else if (user.isOnline == false && user.inCall == false) {
              final currentUser = FirebaseAuth.instance.currentUser!;
              // Creating a conversation document in firebase
              context.read<CallBloc>().add(
                    MakeCallEvent(
                      callerId: currentUser.uid,
                      callerName: currentUser.displayName!,
                      callerPhotoUrl: currentUser.photoURL!,
                      receiverId: userId,
                      receiverName: username,
                      receiverPhotoUrl: photoUrl,
                      callStartTime: DateTime.now().toString(),
                      callEndTime: DateTime.now().toString(),
                    ),
                  );
              // Sending the call notification to the other user
              _sendNotification(
                context,
                currentUser,
                messageContent: Constant.incomingCallMessageContent,
                notificationType: Constant.callNotification,
              );
              // Navigate to the calling screen
              context.router.replace(
                CallingRoute(
                  userId: userId,
                  photoUrl: photoUrl,
                  username: username,
                  token: token,
                  senderToken: senderToken,
                ),
              );
            }
          }
        }
        return const LoadingWidget();
      },
    );
  }

  void _sendNotification(
    BuildContext context,
    User currentUser, {
    required dynamic messageContent,
    required String notificationType,
  }) {
    context.read<NotificationCubit>().sendNotification(
          notificationEntity: NotificationEntity(
            conversationId: userId, // other user's id
            token: token,
            title: currentUser.displayName!,
            body: messageContent,
            photoUrl: photoUrl,
            username: username,
            notificationType: notificationType,
          ),
        );
  }
}
