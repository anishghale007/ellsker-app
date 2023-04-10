import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/card_widget.dart';
import 'package:internship_practice/features/auth/data/models/card_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3B4171),
            Color(0xff1F1F40),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
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
                        hintText: "Buscar por evento ou rolê",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.sourceSansPro(
                          color: ColorUtil.kTertiaryColor,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "FESTIVALS",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorUtil.kTertiaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: festivalList.length,
                      itemBuilder: (context, index) {
                        final data = festivalList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "ROLÊS",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorUtil.kTertiaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: rolesList.length,
                      itemBuilder: (context, index) {
                        final data = rolesList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "FESTAS",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorUtil.kTertiaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: festasList.length,
                      itemBuilder: (context, index) {
                        final data = festasList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
