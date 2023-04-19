import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:intl/intl.dart';

class ConversationTile extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String lastMessage;
  final String lastMessageSenderName;
  final String lastMessageTime;
  // final String imagePath;
  // final String userName;
  // final String message;
  // final String messageTime;
  // final bool hasUnreadMessage;
  // final String? numberOfMessage;
  final VoidCallback onPress;

  const ConversationTile({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.lastMessage,
    required this.lastMessageSenderName,
    required this.lastMessageTime,
    // required this.imagePath,
    // required this.userName,
    // required this.message,
    // required this.messageTime,
    // required this.hasUnreadMessage,
    required this.onPress,
    // this.numberOfMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.displayName;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (context) {},
            borderRadius: BorderRadius.circular(6),
            icon: Icons.autorenew,
            foregroundColor: ColorUtil.kIconColor,
            label: "Update",
            backgroundColor: ColorUtil.kSecondaryColor.withOpacity(0.8),
          ),
          SlidableAction(
            onPressed: (context) {},
            borderRadius: BorderRadius.circular(6),
            icon: Icons.close,
            label: "Delete",
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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(receiverPhotoUrl),
            radius: 27,
          ),
          title: Text(
            receiverName,
            style: GoogleFonts.sourceSansPro(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          subtitle: lastMessageSenderName == currentUser
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
                    color: ColorUtil.kTertiaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
          // trailing: hasUnreadMessage == true
          //     ? Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Text(
          //             messageTime,
          //             style: GoogleFonts.sourceSansPro(
          //               color: ColorUtil.kTertiaryColor,
          //               fontWeight: FontWeight.w400,
          //               fontSize: 14,
          //             ),
          //           ),
          //           Container(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 10,
          //               vertical: 1,
          //             ),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(50),
          //               color: ColorUtil.kMessageAlertColor,
          //             ),
          //             child: Text(
          //               numberOfMessage!,
          //               style: GoogleFonts.sourceSansPro(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 14,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          trailing: lastMessageSenderName == currentUser
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
                ),
        ),
      ),
    );
  }
}
