import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/loader_widget.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/enums/message_type_enum.dart';
import 'package:internship_practice/core/functions/app_dialogs.dart';
import 'package:internship_practice/features/call/presentation/bloc/token/token_bloc.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/chat_box_widget.dart';
import 'package:internship_practice/features/auth/presentation/bloc/network/network_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/conversation_entity.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message_send_button_widget.dart';
import 'package:internship_practice/features/chat/presentation/widgets/user_profile_widget.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/routes/router.gr.dart';
import 'package:record/record.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isShowSendButton = false;
  bool isRecording = false;
  final record = Record();
  final String gifApiKey =
      dotenv.get(Constant.gifApiKey, fallback: 'Not found');
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late TextEditingController _messageController;
  final _form = GlobalKey<FormState>();
  String? myToken = "";
  double? latitude;
  double? longitude;
  XFile? pickedImage;
  XFile? pickedVideo;
  GiphyGif? gif;
  late String gifUrl;

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

  Future<void> getImage({
    required bool isFromGallery,
  }) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
        source:
            isFromGallery == true ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50,
      );
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<void> getVideo() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final video = await imagePicker.pickVideo(
        maxDuration: const Duration(minutes: 5),
        source: ImageSource.gallery,
      );
      setState(() {
        pickedVideo = video;
        _messageController.text = video!.path;
      });
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future getGIF() async {
    gif = await GiphyGet.getGif(
      context: context,
      apiKey: gifApiKey,
      lang: GiphyLanguage.english,
      randomID: "abcd",
      tabColor: Colors.teal,
      debounceTimeInMilliseconds: 350,
    ).then((value) {
      gifUrl = value!.images!.original!.url;
      log("URL: $gifUrl");
      _sendMessage(
        context,
        currentUser,
        messageContent: Constant.gifMessageContent,
        messageType: MessageType.gif,
        gifUrl: value.images!.original!.url,
      );
      return value;
    }, onError: (error) {
      log(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationPermission? locationPermission;

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
        // autovalidateMode: AutovalidateMode.always,
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
            title: UserProfileWidget(
              userId: widget.userId,
              username: widget.username,
              photoUrl: widget.photoUrl,
            ),
            actions: [
              BlocListener<TokenBloc, TokenState>(
                listener: (context, state) {
                  if (state is CallSuccess) {
                    log("Token: ${state.videoCallEntity.rtcToken}");
                  } else if (state is CallError) {
                    log("Error");
                  }
                },
                child: IconButton(
                  onPressed: () {
                    context.router.push(
                      IncomingCallRoute(
                        receiverId: widget.userId,
                        receiverName: widget.username,
                        receiverPhotoUrl: widget.photoUrl,
                      ),
                    );
                    context.read<TokenBloc>().add(
                          const GetRtcTokenEvent(
                            channelName: "test",
                            role: "publisher",
                            tokenType: "userAccount",
                            uid: "10",
                          ),
                        );
                  },
                  icon: const Icon(
                    Icons.video_call,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              PopupMenuButton<int>(
                offset: const Offset(0, 30),
                elevation: 2,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.photo,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Media and Files"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.call,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Call History"),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    context.router.push(
                      SharedFilesRoute(
                        receiverId: widget.userId,
                      ),
                    );
                  }
                },
                child: const Icon(Icons.more_vert),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
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
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 50,
                          ),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var data = snapshot.data?[index];
                            return ChatBoxWidget(
                              messageId: data!.messageId!,
                              messageContent: data.messageContent,
                              messageTime: data.messageTime,
                              receiverId: data.receiverId,
                              receiverName: data.receiverName,
                              receiverPhotoUrl: data.receiverPhotoUrl,
                              senderId: data.senderId,
                              senderName: data.senderName,
                              senderPhotoUrl: data.senderPhotoUrl,
                              messageType: data.messageType,
                              fileUrl: data.fileUrl!,
                              latitude: data.latitude!,
                              longitude: data.longitude!,
                              gifUrl: data.gifUrl!,
                            );
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingWidget();
                      } else {
                        return Container();
                      }
                    },
                  ),
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
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      } else {
                        setState(() {
                          isShowSendButton = false;
                        });
                      }
                    },
                    readOnly: pickedImage != null ||
                            pickedVideo != null ||
                            latitude != null && longitude != null
                        ? true
                        : false,
                    validator: pickedImage != null ||
                            pickedVideo != null ||
                            latitude != null
                        ? null
                        : (value) {
                            if (value!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                    // pickedImage != null
                    //     ? null
                    //     : latitude != null
                    //         ? null
                    //         : (value) {
                    //             if (value!.isEmpty) {
                    //               return "";
                    //             }
                    //             return null;
                    //           },
                    keyboardAppearance: Brightness.dark,
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(fontSize: 0.01),
                      fillColor: Colors.grey[800],
                      filled: true,
                      hintStyle: GoogleFonts.sourceSansPro(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      prefixIcon: latitude == null && longitude == null
                          ? IconButton(
                              onPressed: () {
                                AppDialogs.showImageDialog(
                                  context: context,
                                  canPickVideo: true,
                                  title: const Text("Choose an action"),
                                  onCameraAction: () {
                                    Navigator.of(context).pop();
                                    getImage(isFromGallery: false);
                                  },
                                  onGalleryVideoAction: () {
                                    Navigator.of(context).pop();
                                    getVideo();
                                  },
                                  onGalleryImageAction: () {
                                    Navigator.of(context).pop();
                                    getImage(isFromGallery: true);
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.image_outlined,
                                color: ColorUtil.kIconColor,
                              ),
                            )
                          : null,
                      suffixIcon: pickedImage != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 2,
                                ),
                                Container(
                                  height: 60,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: 20,
                                    top: 7,
                                    bottom: 7,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(pickedImage!.path),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pickedImage = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove_outlined,
                                    color: ColorUtil.kTertiaryColor,
                                  ),
                                ),
                              ],
                            )
                          : pickedVideo != null ||
                                  latitude != null && longitude != null
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pickedVideo = null;
                                      latitude = null;
                                      longitude = null;
                                      _messageController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove_outlined,
                                    color: ColorUtil.kTertiaryColor,
                                  ),
                                )
                              : isShowSendButton == false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            getGIF();
                                          },
                                          icon: Icon(
                                            Icons.gif_box,
                                            color: ColorUtil.kIconColor,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            locationPermission =
                                                await Geolocator
                                                    .requestPermission();
                                            if (locationPermission ==
                                                LocationPermission.denied) {
                                              locationPermission =
                                                  await Geolocator
                                                      .requestPermission();
                                            } else if (locationPermission ==
                                                LocationPermission
                                                    .deniedForever) {
                                              await Geolocator
                                                  .openAppSettings();
                                            } else if (locationPermission ==
                                                    LocationPermission.always ||
                                                locationPermission ==
                                                    LocationPermission
                                                        .whileInUse) {
                                              final response = await Geolocator
                                                  .getCurrentPosition();
                                              setState(() {
                                                longitude = response.longitude;
                                                latitude = response.latitude;
                                                _messageController.text =
                                                    "Lat: $latitude || Long: $longitude";
                                                log("Longitude: $longitude");
                                                log("Latitude: $latitude");
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.location_on,
                                            color: ColorUtil.kIconColor,
                                          ),
                                        ),
                                      ],
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
                    // buttonIcon: isShowSendButton == true
                    //     ? Icons.send_outlined
                    //     : isRecording == false
                    //         ? Icons.mic
                    //         : Icons.close,
                    buttonIcon: isShowSendButton == true ||
                            pickedImage != null ||
                            pickedVideo != null ||
                            latitude != null
                        ? Icons.send_outlined
                        : isRecording
                            ? Icons.stop
                            : Icons.mic,
                    onPress: isShowSendButton == true ||
                            pickedImage != null ||
                            pickedVideo != null ||
                            latitude != null
                        ? () async {
                            _form.currentState!.save();
                            FocusScope.of(context).unfocus();
                            if (_form.currentState!.validate()) {
                              if (pickedImage != null) {
                                // If the user picks an image
                                _sendMessage(
                                  context,
                                  currentUser,
                                  messageContent: Constant.photoMessageContent,
                                  messageType: MessageType.photo,
                                  photoFile: pickedImage,
                                );
                                setState(() {
                                  pickedImage = null;
                                });
                              } else if (pickedVideo != null) {
                                // If the user picks a video
                                _sendMessage(
                                  context,
                                  currentUser,
                                  messageContent: Constant.videoMessageContent,
                                  messageType: MessageType.video,
                                  videoFile: pickedVideo,
                                );
                                setState(() {
                                  pickedVideo = null;
                                });
                              } else if (latitude != null ||
                                  longitude != null) {
                                // If the user sends a location message
                                _sendMessage(
                                  context,
                                  currentUser,
                                  messageContent:
                                      Constant.locationMessageContent,
                                  messageType: MessageType.location,
                                  latitude: latitude.toString(),
                                  longitude: longitude.toString(),
                                );
                                setState(() {
                                  latitude = null;
                                  longitude = null;
                                });
                              } else {
                                // If the user does not pick an image and sends a text message
                                _sendMessage(
                                  context,
                                  currentUser,
                                  messageContent:
                                      _messageController.text.trim(),
                                  messageType: MessageType.text,
                                );
                              }
                            }
                          }
                        : () async {
                            File file;
                            String? filePath;
                            if (await record.hasPermission()) {
                              if (isRecording) {
                                filePath = await record.stop();
                                file = File(filePath!);
                                log("FilePath: $filePath");
                                if (mounted) {
                                  _sendMessage(
                                    context,
                                    currentUser,
                                    messageContent:
                                        Constant.voiceMessageContent,
                                    messageType: MessageType.audio,
                                    audioFile: file,
                                  );
                                  setState(() {
                                    isRecording = !isRecording;
                                  });
                                }
                              } else {
                                if (mounted) {
                                  setState(() {
                                    isRecording = !isRecording;
                                  });
                                  await record.start();
                                }
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
              receiverId: widget.userId,
              receiverName: widget.username,
              receiverPhotoUrl: widget.photoUrl,
              senderId: currentUser.uid, // me
              senderName: currentUser.displayName!,
              senderPhotoUrl: currentUser.photoURL!,
              lastMessage: messageContent,
              lastMessageTime: DateTime.now().toString(),
              lastMessageSenderName: currentUser.displayName!,
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
            messageContent: messageContent,
            messageTime: DateTime.now().toString(),
            senderId: currentUser.uid,
            senderName: currentUser.displayName!,
            senderPhotoUrl: currentUser.photoURL!,
            receiverId: widget.userId,
            receiverName: widget.username,
            receiverPhotoUrl: widget.photoUrl,
            messageType: messageType,
            photoFile: photoFile,
            videoFile: videoFile,
            audioFile: audioFile,
            latitude: latitude,
            longitude: longitude,
            gifUrl: gifUrl,
          ),
        );
    context.read<NotificationCubit>().sendNotification(
          notificationEntity: NotificationEntity(
            conversationId: widget.userId,
            token: widget.token,
            title: currentUser.displayName!,
            body: messageContent,
            photoUrl: widget.photoUrl,
            username: widget.username,
          ),
        );
  }
}
