import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/profile_header_widget.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
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
                        buttonText: AppStrings.edit,
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
                      child: CachedNetworkImage(
                        imageUrl: data!['photoUrl'],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            CircularProgressIndicator(
                                value: progress.progress,
                                backgroundColor: Colors.white),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Text(
                        "${data['username']} , ${data['age']}",
                        style: GoogleFonts.sourceSansPro(
                          fontWeight: FontWeight.w400,
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
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
                                  fontSize: 14,
                                  color: ColorUtil.kTertiaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        Text(
                          "@${data['email']}",
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: ColorUtil.kTertiaryColor,
                          ),
                        ),
                      ],
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
