import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/router.dart';
import 'package:internship_practice/ui_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routers.generateRoute,
      initialRoute: kLoginScreenPath,
      theme: ThemeData(
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
      ),
    );
  }
}
