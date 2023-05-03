import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/ui_pages.dart';

import '../bloc/conversation/conversation_bloc.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocProvider<ConversationCubit>(
              create: (context) =>
                  sl<ConversationCubit>()..getAllConversations(),
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
                      "Conversations",
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
                  BlocBuilder<ConversationCubit, ConversationState>(
                    builder: (context, state) {
                      if (state is ConversationLoaded) {
                        return ListView.builder(
                          itemCount: state.conversationList.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = state.conversationList[index];
                            return ConversationTile(
                              onPress: () {
                                // context.read<ConversationCubit>().seenMessage(
                                //     conversationId: data.receiverId);
                                context.read<ConversationBloc>().add(
                                    SeenConversationEvent(
                                        conversationId: data.receiverId));
                                Navigator.of(context).pushNamed(
                                  kChatScreenPath,
                                  arguments: {
                                    "username": data.receiverName,
                                    "userId": data.receiverId,
                                    "photoUrl": data.receiverPhotoUrl,
                                  },
                                );
                              },
                              receiverId: data.receiverId,
                              receiverName: data.receiverName,
                              receiverPhotoUrl: data.receiverPhotoUrl,
                              lastMessage: data.lastMessage,
                              lastMessageSenderName: data.lastMessageSenderName,
                              lastMessageTime: data.lastMessageTime,
                              isSeen: data.isSeen,
                              unSeenMessages: data.unSeenMessages.toString(),
                              onDelete: (context) {
                                context.read<ConversationBloc>().add(
                                      DeleteConversationEvent(
                                        conversationId: data.receiverId,
                                      ),
                                    );
                              },
                            );
                          },
                        );
                      } else if (state is ConversationLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ConversationError) {
                        return Text(state.errorMessage.toString());
                      } else if (state is ConversationEmpty) {
                        return const Text(
                            "No conversation. Start a conversation with a user.");
                      } else {
                        log("Conversation List not loaded");
                      }
                      return Container();
                    },
                  ),
                ],
              ),
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
    );
  }
}
