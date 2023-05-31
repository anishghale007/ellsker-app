import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/functions/app_dialogs.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/widgets/conversation_tile_widget.dart';
import 'package:internship_practice/routes/router.gr.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/conversation/conversation_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late TextEditingController _conversationController;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _conversationController = TextEditingController();
  }

  @override
  void dispose() {
    _conversationController.dispose();
    super.dispose();
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      AppStrings.conversations,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream:
                        context.read<ConversationCubit>().getAllConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 8,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[500]!,
                              highlightColor: Colors.grey[100]!,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    radius: 27,
                                  ),
                                  title: Container(
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                  subtitle: Container(
                                    height: 12,
                                    color: Colors.grey,
                                    margin: const EdgeInsets.only(right: 180),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return BlocListener<ConversationBloc,
                                ConversationsState>(
                              listener: (context, state) {
                                if (state is ConversationsEdited) {
                                  Navigator.of(context).pop(false);
                                  _conversationController.clear();
                                } else if (state is ConversationsError) {
                                  log(state.errorMessage.toString());
                                }
                              },
                              child: ConversationTile(
                                onPress: () {
                                  // context.read<ConversationCubit>().seenMessage(
                                  //     conversationId: data.receiverId);
                                  context.read<ConversationBloc>().add(
                                        SeenConversationEvent(
                                            conversationId: data.receiverId),
                                      );
                                  context.router.push(
                                    ChatRoute(
                                      username: data.receiverName,
                                      userId: data.receiverId,
                                      photoUrl: data.receiverPhotoUrl,
                                      token: data.receiverToken,
                                    ),
                                  );
                                },
                                receiverId: data.receiverId,
                                receiverName: data.receiverName,
                                receiverPhotoUrl: data.receiverPhotoUrl,
                                lastMessage: data.lastMessage,
                                lastMessageSenderName:
                                    data.lastMessageSenderName,
                                lastMessageSenderId: data.lastMessageSenderId,
                                lastMessageTime: data.lastMessageTime,
                                isSeen: data.isSeen,
                                unSeenMessages: data.unSeenMessages.toString(),
                                controller: _conversationController
                                  ..text = data.receiverName,
                                onEdit: () {
                                  _form.currentState!.save();
                                  if (_form.currentState!.validate()) {
                                    if (_conversationController.text.isEmpty) {
                                      // Validator not working so using this type of validation
                                      log("Empty");
                                    } else {
                                      context.read<ConversationBloc>().add(
                                            EditConversationEvent(
                                              conversationId: data.receiverId,
                                              newNickname:
                                                  _conversationController.text
                                                      .trim(),
                                            ),
                                          );
                                    }
                                  }
                                },
                                onDelete: (dialogContext) {
                                  AppDialogs.showAlertDialog(
                                    context: dialogContext,
                                    title: const Text(
                                        "Are you sure you want to delete it?"),
                                    content: const Text(
                                        "Once deleted it cannot be undone. The conversation will be deleted from your side only."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<ConversationBloc>().add(
                                                DeleteConversationEvent(
                                                  conversationId:
                                                      data.receiverId,
                                                ),
                                              );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorUtil.kMessageAlertColor,
            onPressed: () {
              // Navigator.pushNamed(context, kUserListScreenPath);
              context.router.push(const UserListRoute());
            },
            child: const Icon(Icons.message),
          ),
        ),
      ),
    );
  }
}
