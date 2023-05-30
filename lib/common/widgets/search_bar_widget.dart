import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
  });

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
        controller: controller,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
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
          hintText: hintText,
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
