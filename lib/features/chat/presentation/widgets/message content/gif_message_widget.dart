import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/receiver_user_message_box.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/sender_user_message_box.dart';
import 'package:intl/intl.dart';

class GifMessageWidget extends StatelessWidget {
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String gifUrl;
  final String messageTime;
  final VoidCallback onSenderLongPress;

  const GifMessageWidget({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.gifUrl,
    required this.messageTime,
    required this.onSenderLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == senderId
        ? SenderUserMessageBox(
            message: Flexible(
              child: GestureDetector(
                onLongPress: onSenderLongPress,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
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
                        child: CachedNetworkImage(
                          imageUrl: gifUrl,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        DateFormat('Hm').format(
                          DateTime.parse(messageTime),
                        ),
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : ReceiverUserMessageBox(
            senderPhotoUrl: senderPhotoUrl,
            senderName: senderName,
            message: Container(
              margin: const EdgeInsets.only(
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(
                // horizontal: 15,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                // color: ColorUtil.kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: CachedNetworkImage(
                      imageUrl: gifUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat('Hm').format(
                      DateTime.parse(messageTime),
                    ),
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
