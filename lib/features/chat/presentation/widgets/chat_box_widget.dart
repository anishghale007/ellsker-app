import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatBoxWidget extends StatelessWidget {
  final String messageContent;
  final String messageTime;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String messageType;
  final String photoUrl;

  const ChatBoxWidget({
    Key? key,
    required this.messageContent,
    required this.messageTime,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.messageType,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == senderId
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Text(
              //   DateFormat('MMM d, h:mm a').format(DateTime.parse(messageTime)),
              //   style: GoogleFonts.sourceSansPro(
              //     color: Colors.grey,
              //     fontSize: 12,
              //   ),
              // ),
              messageType == "photo"
                  ? Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 40,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff6E56FF),
                              Color(0xff4329E5),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 250,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Low,
                                child: CachedNetworkImage(
                                  imageUrl: photoUrl,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat('h:mm')
                                  .format(DateTime.parse(messageTime)),
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 40,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff6E56FF),
                              Color(0xff4329E5),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              messageContent,
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              DateFormat('h:mm')
                                  .format(DateTime.parse(messageTime)),
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CachedNetworkImage(
                imageUrl: senderPhotoUrl,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  foregroundImage: imageProvider,
                  radius: 15,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kTertiaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    messageType == "photo"
                        ? Container(
                            margin: const EdgeInsets.only(
                              right: 20,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: ColorUtil.kPrimaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: SizedBox(
                              height: 250,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Low,
                                child: CachedNetworkImage(
                                  imageUrl: photoUrl,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                              right: 20,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: ColorUtil.kPrimaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  messageContent,
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              Text(
                DateFormat('MMM d, h:mm a').format(DateTime.parse(messageTime)),
                style: GoogleFonts.sourceSansPro(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          );
  }
}
