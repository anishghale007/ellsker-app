import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/call/data/models/call_model.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/injection_container.dart';

class CallingScreen extends StatelessWidget implements AutoRouteWrapper {
  final String userId;
  final String photoUrl;
  final String username;
  final String token;
  final String senderToken;

  const CallingScreen({
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
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('call')
          .doc('$userId-${currentUser.uid}')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if (call.hasDialled == false) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(photoUrl),
                  colorFilter: const ColorFilter.mode(
                    Colors.black87,
                    BlendMode.srcOver,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 110, 110, 117),
                                width: 13,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppStrings.calling,
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            username,
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 200,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.router.pop();
                              // set the hasDialled to false
                              context.read<CallBloc>().add(
                                    EndCallEvent(
                                      callerId: currentUser.uid,
                                      receiverId: userId,
                                      callEndTime: DateTime.now().toString(),
                                    ),
                                  );
                              // missed call notification
                              _sendNotification(
                                context,
                                currentUser,
                                messageContent:
                                    Constant.missedCallMessageContent,
                                notificationType:
                                    Constant.missedCallNotification,
                              );
                              // missed call message
                              _sendMessage(
                                context,
                                currentUser,
                                messageContent:
                                    Constant.missedCallMessageContent,
                                messageType: MessageType.call,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.red,
                            ),
                            child: const Icon(
                              Icons.call_end,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // If the other user picks up the call then navigate to video call screen
            //   // context.router.replace(const VideoCallRoute());
            // Send Call Message
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

  void _sendMessage(
    BuildContext context,
    User currentUser, {
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
}
