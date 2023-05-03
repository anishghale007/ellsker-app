import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/profile_header_widget.dart';
import 'package:internship_practice/ui_pages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.data();
                return Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileHeader(
                        buttonText: "Edit",
                        onPress: () {
                          Navigator.of(context).pushNamed(
                            kEditProfileScreenPath,
                            arguments: {
                              "username": data!['username'],
                              "photoUrl": data['photoUrl'],
                              "instagram": data['instagram'],
                              "location": data['location'],
                              "age": data['age'].toString(),
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      foregroundDecoration: BoxDecoration(
                        color: Colors.green,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [
                            0,
                            0.2,
                            0.6,
                            1,
                          ],
                          colors: [
                            ColorUtil.kPrimaryColor,
                            Colors.transparent,
                            Colors.transparent,
                            ColorUtil.kPrimaryColor,
                          ],
                        ),
                      ),
                      child: Image.network(
                        data!['photoUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Text(
                          "${data['username']} , ${data['age']}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w400,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: ColorUtil.kTertiaryColor,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                text: data['location'],
                                style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color: ColorUtil.kTertiaryColor,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 30,
                                ),
                              ),
                              TextSpan(
                                text: "@${data['email']}",
                                style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color: ColorUtil.kTertiaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
          ),
        ),
      ),
    );
  }
}
