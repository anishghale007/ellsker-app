import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primaryColor: ColorUtil.kPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      hintStyle: GoogleFonts.sourceSansPro(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: ColorUtil.kTextFieldColor,
      ),
    ),
  );
}
