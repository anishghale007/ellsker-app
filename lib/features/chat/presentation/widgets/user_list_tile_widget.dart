import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/ui_pages.dart';

class UserListTileWidget extends StatelessWidget {
  const UserListTileWidget({
    super.key,
    required this.data,
    required this.currentUser,
  });

  final UserEntity data;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ConversationBloc>().add(
              SeenConversationEvent(conversationId: data.userId),
            );
        Navigator.of(context).pushNamed(
          kChatScreenPath,
          arguments: {
            "username": data.userName,
            "userId": data.userId,
            "photoUrl": data.photoUrl,
            "token": data.token,
          },
        );
      },
      child: SizedBox(
        height: data.userId == currentUser ? 0 : 70,
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: data.photoUrl,
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.white,
            ),
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(
              value: progress.progress,
              backgroundColor: Colors.white,
            ),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              foregroundImage: imageProvider,
              radius: 27,
            ),
          ),
          title: Text(
            data.userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          trailing: data.userId == currentUser
              ? null
              : data.isOnline == true
                  ? const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 13,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      color: Colors.grey,
                      size: 13,
                    ),
        ),
      ),
    );
  }
}
