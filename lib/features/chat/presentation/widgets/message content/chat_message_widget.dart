import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/common/widgets/loader_widget.dart';
import 'package:internship_practice/features/chat/domain/entities/message_entity.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_screen.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/chat_box_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatScreen widget;

  const ChatMessageWidget({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageEntity>>(
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else {
          return Container();
        }
      },
    );
  }
}
