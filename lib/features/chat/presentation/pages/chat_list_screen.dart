import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/chat/presentation/cubit/conversation/conversation_cubit.dart';
import 'package:internship_practice/features/chat/presentation/widgets/conversation_tile_widget.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/routes/router.gr.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/conversation/conversation_bloc.dart';

class ChatListScreen extends StatefulWidget implements AutoRouteWrapper {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ConversationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ConversationCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _ChatListScreenState extends State<ChatListScreen> {
  late TextEditingController _conversationController;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    super.didChangeDependencies();
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
                                  _conversationController.clear();
                                } else if (state is ConversationsError) {
                                  log(state.errorMessage.toString());
                                }
                              },
                              child: ConversationTile(
                                onPress: () {
                                  context.read<ConversationBloc>().add(
                                        SeenConversationEvent(
                                          conversationId: data.receiverId,
                                        ),
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
                                receiverNickname: data.receiverNickname,
                                receiverPhotoUrl: data.receiverPhotoUrl,
                                lastMessage: data.lastMessage,
                                lastMessageSenderName:
                                    data.lastMessageSenderName,
                                lastMessageSenderId: data.lastMessageSenderId,
                                lastMessageTime: data.lastMessageTime,
                                isSeen: data.isSeen,
                                unSeenMessages: data.unSeenMessages.toString(),
                                onEditPressed: (editContext) {
                                  showDialog(
                                    context: editContext,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Edit Nickname'),
                                        content: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "This Field is required";
                                            }
                                            return null;
                                          },
                                          controller: _conversationController
                                            ..text = data.receiverNickname,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          textInputAction: TextInputAction.done,
                                          style: GoogleFonts.sourceSansPro(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: "Enter a nickname",
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _form.currentState!.save();
                                              if (_form.currentState!
                                                  .validate()) {
                                                if (_conversationController
                                                    .text.isEmpty) {
                                                  // Validator not working so using this type of validation
                                                  log("Empty");
                                                } else {
                                                  context
                                                      .read<ConversationBloc>()
                                                      .add(
                                                        EditConversationEvent(
                                                          conversationId:
                                                              data.receiverId,
                                                          newNickname:
                                                              _conversationController
                                                                  .text
                                                                  .trim(),
                                                        ),
                                                      );
                                                  Navigator.of(dialogContext)
                                                      .pop(true);
                                                }
                                              }
                                            },
                                            child: const Text('Set'),
                                          ),
                                        ],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                onDeletePressed: (deleteContext) {
                                  showDialog(
                                    context: deleteContext,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Are you sure you want to delete it?"),
                                        content: const Text(
                                            "Once deleted it cannot be undone. The conversation will be deleted from your side only."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(false);
                                            },
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<ConversationBloc>()
                                                  .add(
                                                    DeleteConversationEvent(
                                                      conversationId:
                                                          data.receiverId,
                                                    ),
                                                  );
                                              Navigator.of(dialogContext)
                                                  .pop(true);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
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
              context.router.push(const UserListRoute());
            },
            child: const Icon(Icons.message),
          ),
        ),
      ),
    );
  }
}
