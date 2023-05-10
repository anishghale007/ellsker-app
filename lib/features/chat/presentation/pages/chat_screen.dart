import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/features/chat/presentation/widgets/chat_box_widget.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message_send_button_widget.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';

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
  XFile? pickedImage;

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

  Future<void> getImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      throw (Exception(e.toString()));
    }
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
                  StreamBuilder<List<MessageEntity>>(
                    stream: context
                        .read<MessageCubit>()
                        .getAllChatMessages(conversationId: widget.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 50,
                          ),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return ChatBoxWidget(
                              messageContent: data.messageContent,
                              messageTime: data.messageTime,
                              receiverId: data.receiverId,
                              receiverName: data.receiverName,
                              receiverPhotoUrl: data.receiverPhotoUrl,
                              senderId: data.senderId,
                              senderName: data.senderName,
                              senderPhotoUrl: data.senderPhotoUrl,
                              messageType: data.messageType,
                              photoUrl: data.photoUrl!,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  // BlocProvider<MessageCubit>(
                  //   create: (context) => sl<MessageCubit>()
                  //     ..getAllChatMessages(conversationId: widget.userId),
                  //   child: BlocBuilder<MessageCubit, MessageState>(
                  //     builder: (context, state) {
                  //       if (state is MessageLoaded) {
                  //         log("Message Loaded");
                  //         return ListView.separated(
                  //           separatorBuilder: (context, index) => const Divider(
                  //             height: 30,
                  //           ),
                  //           itemCount: state.messageList.length,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           scrollDirection: Axis.vertical,
                  //           itemBuilder: (context, index) {
                  //             final data = state.messageList[index];
                  //             return ChatBoxWidget(
                  //               messageContent: data.messageContent,
                  //               messageTime: data.messageTime,
                  //               receiverId: data.receiverId,
                  //               receiverName: data.receiverName,
                  //               receiverPhotoUrl: data.receiverPhotoUrl,
                  //               senderId: data.senderId,
                  //               senderName: data.senderName,
                  //               senderPhotoUrl: data.senderPhotoUrl,
                  //               messageType: data.messageType,
                  //               photoUrl: data.photoUrl!,
                  //             );
                  //           },
                  //         );
                  //       } else if (state is MessageLoading) {
                  //         return const Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       } else if (state is MessageError) {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: Text(state.errorMessage.toString()),
                  //             duration: const Duration(seconds: 5),
                  //           ),
                  //         );
                  //       } else {
                  //         log("Message Not Loaded");
                  //       }
                  //       return Container();
                  //     },
                  //   ),
                  // ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            // height: 55,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    minLines: 1,
                    maxLines: 3,
                    readOnly: pickedImage != null ? true : false,
                    validator: pickedImage != null
                        ? null
                        : (value) {
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
                      hintText: pickedImage != null ? pickedImage!.name : "",
                      hintStyle: GoogleFonts.sourceSansPro(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(
                          Icons.image_outlined,
                          color: ColorUtil.kIconColor,
                        ),
                      ),
                      suffixIcon: pickedImage != null
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  pickedImage = null;
                                });
                              },
                              icon: Icon(
                                Icons.highlight_remove_outlined,
                                color: ColorUtil.kTertiaryColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<NetworkBloc, NetworkState>(
                      listener: (context, state) {
                        if (state is NetworkFailure) {
                          log("Not connected to Internet");
                        } else if (state is NetworkSuccess) {
                          log("Connected to Internet");
                        } else {
                          log("Not working");
                        }
                      },
                    ),
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
                  child: MessageSendButtonWidget(
                    onPress: () {
                      _form.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_form.currentState!.validate()) {
                        final currentUser = FirebaseAuth.instance.currentUser!;
                        if (pickedImage != null) {
                          // If the user picks an image
                          context.read<ConversationBloc>().add(
                                CreateConversationEvent(
                                  conversationEntity: ConversationEntity(
                                    receiverId: widget.userId,
                                    receiverName: widget.username,
                                    receiverPhotoUrl: widget.photoUrl,
                                    senderId: currentUser.uid, // me
                                    senderName: currentUser.displayName!,
                                    senderPhotoUrl: currentUser.photoURL!,
                                    lastMessage: Constant.photoMessageContent,
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
                                  messageContent: Constant.photoMessageContent,
                                  messageTime: DateTime.now().toString(),
                                  senderId: currentUser.uid,
                                  senderName: currentUser.displayName!,
                                  senderPhotoUrl: currentUser.photoURL!,
                                  receiverId: widget.userId,
                                  receiverName: widget.username,
                                  receiverPhotoUrl: widget.photoUrl,
                                  messageType: MessageType.photo.name,
                                  image: pickedImage,
                                ),
                              );
                          context.read<NotificationCubit>().sendNotification(
                                notificationEntity: NotificationEntity(
                                  conversationId: widget.userId,
                                  token: widget.token,
                                  title: currentUser.displayName!,
                                  body: Constant.photoMessageContent,
                                  photoUrl: widget.photoUrl,
                                  username: widget.username,
                                ),
                              );
                          setState(() {
                            pickedImage = null;
                          });
                        } else {
                          // If the user does not pick an image and sends a text message
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
                                  messageType: MessageType.text.name,
                                ),
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
                      }
                    },
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
