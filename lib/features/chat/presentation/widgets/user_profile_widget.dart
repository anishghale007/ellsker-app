import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileWidget extends StatelessWidget {
  final String userId;
  final String username;
  final String photoUrl;

  const UserProfileWidget({
    super.key,
    required this.userId,
    required this.username,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showUserProfile(context),
      child: Text(
        username,
        style: GoogleFonts.sourceSansPro(
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
    );
  }

  void showUserProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            var data = snapshot.data!.data();
            if (snapshot.hasData) {
              return SizedBox(
                height: 450,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      username,
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      data!['email'],
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                            text: '   ${data['age'].toString()}',
                            style: GoogleFonts.sourceSansPro(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                            text: '   ${data['location']}',
                            style: GoogleFonts.sourceSansPro(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                            text: '   ${data['instagram']}',
                            style: GoogleFonts.sourceSansPro(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          },
        );
      },
    );
  }
}
