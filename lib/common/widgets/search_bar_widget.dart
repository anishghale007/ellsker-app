import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: ColorUtil.kSecondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        style: GoogleFonts.sourceSansPro(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            size: 24,
            color: Colors.white.withOpacity(0.7),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          isDense: true,
          hintText: AppStrings.searchByEventOrTour,
          border: InputBorder.none,
          hintStyle: GoogleFonts.sourceSansPro(
            color: ColorUtil.kTertiaryColor,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
