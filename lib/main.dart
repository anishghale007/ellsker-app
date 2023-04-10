import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/router.dart';
import 'package:internship_practice/ui_pages.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
