import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/routes/router.gr.dart';

class CallingScreen extends StatelessWidget {
  final String userId;
  final String photoUrl;
  final String username;

  const CallingScreen({
    super.key,
    required this.userId,
    required this.photoUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        var data = snapshot.data?.data();
        if (snapshot.hasData && snapshot.data != null) {
          if (data!['isOnline'] == true) {
            // If the user is not online
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(photoUrl),
                  colorFilter: const ColorFilter.mode(
                    Colors.black87,
                    BlendMode.srcOver,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 110, 110, 117),
                              width: 13,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          username,
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "$username is offline. Please call at another moment",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        // send missed call message
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // If the user is online then go to the video call screen
            context.router.push(const VideoCallRoute());
          }
        }
        return Container();
      },
    );
  }
}
