import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class HeaderWidget extends StatelessWidget {
  final String header;

  const HeaderWidget({
    super.key,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      header,
      style: GoogleFonts.sourceSansPro(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorUtil.kTertiaryColor,
      ),
    );
  }
}
