import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/features/auth/data/models/message_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3A4070),
            Color(0xff1F1F40),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              height: 0.2,
              color: Colors.grey,
            ),
          ),
          title: Text(
            "Rolê Leblon",
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Hoje, 23:45",
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 30,
                  ),
                  itemCount: messageList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final data = messageList[index];
                    return ChatBoxWidget(
                      imagePath: data.imagePath,
                      userName: data.userName,
                      message: data.message,
                      fromMe: data.fromMe,
                    );
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorUtil.kSecondaryColor,
            border: Border.all(
              width: 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 36,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  style: GoogleFonts.sourceSansPro(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[800],
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    prefixIcon: Icon(
                      Icons.image_outlined,
                      color: ColorUtil.kIconColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffE45699),
                      Color(0xff733DD6),
                      Color(0xff3D88E4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
