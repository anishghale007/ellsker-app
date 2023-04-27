// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class CustomTextField extends StatelessWidget {
  final String heading;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    Key? key,
    required this.heading,
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.textInputAction,
    required this.validator,
    required this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: GoogleFonts.sourceSansPro(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorUtil.kTertiaryColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: ColorUtil.kTextFieldColor,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              validator: validator,
              style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
