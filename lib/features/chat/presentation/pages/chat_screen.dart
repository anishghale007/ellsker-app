import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/chat_box_widget.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/injection_container.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String userId;
  final String photoUrl;
  final String token;

  const ChatScreen({
    required this.username,
    required this.userId,
    required this.photoUrl,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late TextEditingController _messageController;
  final _form = GlobalKey<FormState>();
  String? myToken = "";

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    getToken();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        setState(() {
          myToken = token;
          log("MyToken: $myToken");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3A4070),
            Color(0xff1F1F40),
          ],
        ),
      ),
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                height: 0.2,
                color: Colors.grey,
              ),
            ),
            title: Text(
              widget.username,
              style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  BlocProvider<MessageCubit>(
                    create: (context) => sl<MessageCubit>()
                      ..getAllMessages(conversationId: widget.userId),
                    child: BlocBuilder<MessageCubit, MessageState>(
                      builder: (context, state) {
                        if (state is MessageLoaded) {
                          log("Message Loaded");
                          return ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 30,
                            ),
                            itemCount: state.messageList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final data = state.messageList[index];
                              return ChatBoxWidget(
                                messageContent: data.messageContent,
                                messageTime: data.messageTime,
                                receiverId: data.receiverId,
                                receiverName: data.receiverName,
                                receiverPhotoUrl: data.receiverPhotoUrl,
                                senderId: data.senderId,
                                senderName: data.senderName,
                                senderPhotoUrl: data.senderPhotoUrl,
                              );
                            },
                          );
                        } else if (state is MessageLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MessageError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage.toString()),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        } else {
                          log("Message Not Loaded");
                        }
                        return Container();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorUtil.kSecondaryColor,
              border: Border.all(
                width: 0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 36,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    keyboardAppearance: Brightness.dark,
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(fontSize: 0.01),
                      fillColor: Colors.grey[800],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: Icon(
                        Icons.image_outlined,
                        color: ColorUtil.kIconColor,
                      ),
                    ),
                  ),
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<ConversationBloc, ConversationsState>(
                      listener: (context, state) {
                        if (state is ConversationsCreated) {
                          log("Conversation created successfully.");
                        } else if (state is ConversationsError) {
                          log(state.errorMessage);
                        }
                      },
                    ),
                    BlocListener<MessageCubit, MessageState>(
                      listener: (context, state) {
                        if (state is MessageSuccess) {
                          log("Message sent successfully");
                          _messageController.clear();
                          FocusScope.of(context).unfocus();
                        } else if (state is MessageError) {
                          log(state.errorMessage);
                        }
                      },
                    ),
                    BlocListener<NotificationCubit, NotificationState>(
                      listener: (context, state) {
                        if (state is NotificationSuccess) {
                          log("Notification sent successfully");
                          _messageController.clear();
                          FocusScope.of(context).unfocus();
                        } else if (state is NotificationError) {
                          log("Notification Error:${state.errorMessage}");
                        } else {
                          log("Notification not sent");
                        }
                      },
                    ),
                  ],
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffE45699),
                          Color(0xff733DD6),
                          Color(0xff3D88E4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _form.currentState!.save();
                        FocusScope.of(context).unfocus();
                        if (_form.currentState!.validate()) {
                          final currentUser =
                              FirebaseAuth.instance.currentUser!;
                          context.read<ConversationBloc>().add(
                                CreateConversationEvent(
                                  conversationEntity: ConversationEntity(
                                    receiverId: widget.userId,
                                    receiverName: widget.username,
                                    receiverPhotoUrl: widget.photoUrl,
                                    senderId: currentUser.uid, // me
                                    senderName: currentUser.displayName!,
                                    senderPhotoUrl: currentUser.photoURL!,
                                    lastMessage: _messageController.text.trim(),
                                    lastMessageTime: DateTime.now().toString(),
                                    lastMessageSenderName:
                                        currentUser.displayName!,
                                    lastMessageSenderId: currentUser.uid,
                                    isSeen: false,
                                    unSeenMessages: 0,
                                    receiverToken: widget.token,
                                    senderToken: myToken!,
                                  ),
                                ),
                              );
                          context.read<MessageCubit>().sendMessage(
                                messageEntity: MessageEntity(
                                  messageContent:
                                      _messageController.text.trim(),
                                  messageTime: DateTime.now().toString(),
                                  senderId: currentUser.uid,
                                  senderName: currentUser.displayName!,
                                  senderPhotoUrl: currentUser.photoURL!,
                                  receiverId: widget.userId,
                                  receiverName: widget.username,
                                  receiverPhotoUrl: widget.photoUrl,
                                ),
                              );
                          context.read<MessageCubit>().getAllMessages(
                                conversationId: widget.userId,
                              );
                          // context.read<NotificationBloc>().add(
                          //       SendNotificationEvent(
                          //         notificationEntity: NotificationEntity(
                          //           token: widget.token,
                          //           title: widget.username,
                          //           body: _messageController.text.trim(),
                          //         ),
                          //       ),
                          //     );
                          context.read<NotificationCubit>().sendNotification(
                                notificationEntity: NotificationEntity(
                                  conversationId: widget.userId,
                                  token: widget.token,
                                  title: currentUser.displayName!,
                                  body: _messageController.text.trim(),
                                  photoUrl: widget.photoUrl,
                                  username: widget.username,
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.only(left: 5),
                      ),
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
