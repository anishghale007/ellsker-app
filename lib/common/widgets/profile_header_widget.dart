import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class ProfileHeader extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;

  const ProfileHeader({
    Key? key,
    required this.buttonText,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Profile",
          style: GoogleFonts.sourceSansPro(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: onPress,
          child: buttonText == "Save"
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: GoogleFonts.sourceSansPro(
                        color: ColorUtil.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                    border: Border.all(
                      width: 0.5,
                      color: ColorUtil.kTertiaryColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
