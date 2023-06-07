import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/call/data/models/call_model.dart';
import 'package:internship_practice/routes/router.gr.dart';

class IncomingCallScreen extends StatelessWidget {
  final Widget scaffold;

  const IncomingCallScreen({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('call')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if (!call.hasDialled) {
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
                    child: Center(
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
                              backgroundImage:
                                  NetworkImage(call.callerPhotoUrl),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppStrings.incomingCall,
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            call.callerName,
                            style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 200,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.router.pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.call_end,
                                  size: 50,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.router.push(const VideoCallRoute());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Icon(
                                  Icons.call,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
