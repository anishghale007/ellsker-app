import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/chat/presentation/widgets/message%20content/receiver_user_message_box.dart';
import 'package:intl/intl.dart';

class LocationMessageWidget extends StatelessWidget {
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String latitude;
  final String longitude;
  final String messageTime;
  final VoidCallback onSenderLongPress;
  final VoidCallback onTap;

  const LocationMessageWidget({
    super.key,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.latitude,
    required this.longitude,
    required this.messageTime,
    required this.onSenderLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == senderId
        ? Flexible(
            child: GestureDetector(
              onLongPress: onSenderLongPress,
              onTap: onTap,
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
                      "Latitude: $latitude \nLongitude: $longitude ",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tap on the box to view it in a map',
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
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
          )
        : ReceiverUserMessageBox(
            senderName: senderName,
            senderPhotoUrl: senderPhotoUrl,
            message: InkWell(
              onTap: onTap,
              child: Container(
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
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latitude: $latitude \nLongitude: $longitude ",
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tap on the box to view it in a map',
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
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
          );
  }
}
