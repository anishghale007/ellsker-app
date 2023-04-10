import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/common/widgets/chat_tile_widget.dart';
import 'package:internship_practice/features/auth/data/models/chat_model.dart';
import 'package:internship_practice/ui_pages.dart';

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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    "Conversations",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  itemCount: chatList.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final data = chatList[index];
                    return ChatTile(
                      onPress: () {
                        Navigator.of(context).pushNamed(kChatDetailsScreenPath);
                      },
                      imagePath: data.imagePath,
                      userName: data.userName,
                      message: data.message,
                      messageTime: data.messageTime,
                      hasUnreadMessage: data.hasUnreadMessage,
                      numberOfMessage: data.numberOfMessage,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
