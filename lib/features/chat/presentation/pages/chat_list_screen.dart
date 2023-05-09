import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/ui_pages.dart';

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
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
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
                                  Navigator.of(context).pushNamed(
                                    kChatScreenPath,
                                    arguments: {
                                      "username": data.receiverName,
                                      "userId": data.receiverId,
                                      "photoUrl": data.receiverPhotoUrl,
                                      "token": data.receiverToken,
                                    },
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
                                onDelete: (context) {
                                  context.read<ConversationBloc>().add(
                                        DeleteConversationEvent(
                                          conversationId: data.receiverId,
                                        ),
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
              Navigator.pushNamed(context, kUserListScreenPath);
            },
            child: const Icon(Icons.message),
          ),
        ),
      ),
    );
  }
}
