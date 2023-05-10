import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class UserInfoWidget extends StatelessWidget {
  final String username;
  final String age;
  final String location;
  final String email;

  const UserInfoWidget({
    super.key,
    required this.username,
    required this.age,
    required this.location,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "$username , $age",
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
                    text: location,
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
              "@$email",
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
  }
}
