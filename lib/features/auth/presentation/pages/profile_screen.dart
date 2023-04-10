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
    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileHeader(
                  buttonText: "Edit",
                  onPress: () {
                    Navigator.of(context).pushNamed(kEditProfileScreenPath);
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
                child: Image.asset(
                  "assets/images/profile_picture.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Center(
                child: Text(
                  "${FirebaseAuth.instance.currentUser!.displayName!} , 26",
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
                          text: "Ipanema",
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
                    "@${FirebaseAuth.instance.currentUser!.email}",
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: ColorUtil.kTertiaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
