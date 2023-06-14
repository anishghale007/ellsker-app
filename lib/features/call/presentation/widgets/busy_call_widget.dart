import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';

class BusyCallWidget extends StatelessWidget {
  final String photoUrl;
  final String username;
  final bool isOffline;

  const BusyCallWidget({
    super.key,
    required this.photoUrl,
    required this.username,
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(photoUrl),
          colorFilter: const ColorFilter.mode(
            Colors.black87,
            BlendMode.srcOver,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 110, 110, 117),
                      width: 13,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  username,
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  isOffline == true
                      ? "$username is offline. Please call at another moment"
                      : "$username is in another call. Please call at another moment",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtil.kMessageAlertColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        context.router.pop();
                      },
                      child: const Text(
                        "Go Back",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // send missed call message
              ],
            ),
          ),
        ),
      ),
    );
  }
}
