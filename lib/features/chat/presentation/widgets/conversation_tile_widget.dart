import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationTile extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String lastMessage;
  final String lastMessageSenderName;
  final String lastMessageSenderId;
  final String lastMessageTime;
  final bool isSeen;
  final String unSeenMessages;
  final TextEditingController controller;
  final VoidCallback onPress;
  final VoidCallback onEdit;
  final Function(BuildContext) onDelete;

  const ConversationTile({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.lastMessage,
    required this.lastMessageSenderName,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
    required this.isSeen,
    required this.unSeenMessages,
    required this.controller,
    required this.onPress,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Edit Nickname'),
                    content: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This Field is required";
                        }
                        return null;
                      },
                      controller: controller,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
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
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: onEdit,
                        child: const Text('Set'),
                      ),
                    ],
                  );
                },
              );
            },
            borderRadius: BorderRadius.circular(6),
            icon: Icons.autorenew,
            foregroundColor: ColorUtil.kIconColor,
            label: AppStrings.update,
            backgroundColor: ColorUtil.kSecondaryColor.withOpacity(0.8),
          ),
          SlidableAction(
            onPressed: onDelete,
            borderRadius: BorderRadius.circular(6),
            icon: Icons.close,
            label: AppStrings.delete,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: ListTile(
          onTap: onPress,
          leading: CachedNetworkImage(
            imageUrl: receiverPhotoUrl,
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
            receiverName,
            style: GoogleFonts.sourceSansPro(
              fontSize: 18,
              fontWeight: isSeen == true ? FontWeight.w400 : FontWeight.w700,
              color: Colors.white,
            ),
          ),
          subtitle: lastMessageSenderId == currentUser
              ? Text(
                  "You: $lastMessage",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.sourceSansPro(
                    color: ColorUtil.kTertiaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                )
              : Text(
                  "$lastMessageSenderName: $lastMessage",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.sourceSansPro(
                    color: isSeen == true
                        ? ColorUtil.kTertiaryColor
                        : Colors.white70,
                    fontWeight:
                        isSeen == true ? FontWeight.w400 : FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
          trailing: lastMessageSenderId == currentUser
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat()
                          .add_Hm()
                          .format(DateTime.parse(lastMessageTime)),
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kTertiaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${timeago.format(DateTime.parse(lastMessageTime), locale: 'en_short')} ago",
                      // DateFormat()
                      //     .add_Hm()
                      //     .format(DateTime.parse(lastMessageTime)),
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kTertiaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    unSeenMessages == "0"
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              unSeenMessages,
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.transparent,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorUtil.kMessageAlertColor,
                            ),
                            child: Text(
                              unSeenMessages,
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
