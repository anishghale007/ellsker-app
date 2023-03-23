import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class ChatTile extends StatelessWidget {
  final String imagePath;
  final String userName;
  final String message;
  final String messageTime;
  final bool hasUnreadMessage;
  final String? numberOfMessage;
  final VoidCallback onPress;

  const ChatTile({
    Key? key,
    required this.imagePath,
    required this.userName,
    required this.message,
    required this.messageTime,
    required this.hasUnreadMessage,
    required this.onPress,
    this.numberOfMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            backgroundImage: AssetImage(imagePath),
            radius: 27,
          ),
          title: Text(
            userName,
            style: GoogleFonts.sourceSansPro(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.sourceSansPro(
              color: ColorUtil.kTertiaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          trailing: hasUnreadMessage == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      messageTime,
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kTertiaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorUtil.kMessageAlertColor,
                      ),
                      child: Text(
                        numberOfMessage!,
                        style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      messageTime,
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kTertiaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
          // trailing: Column(
          //   children: [
          //     Text(
          //       messageTime,
          //       style: GoogleFonts.sourceSansPro(
          //         color: ColorUtil.kTertiaryColor,
          //         fontWeight: FontWeight.w400,
          //         fontSize: 14,
          //       ),
          //     ),
          //     hasUnreadMessage == true
          //         ? Container(
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
          //           )
          //         : Container(),
          //   ],
          // ),
        ),
      ),
    );
  }
}
