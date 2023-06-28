import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/profile/presentation/widgets/profile_picture_widget.dart';
import 'package:internship_practice/features/profile/presentation/widgets/user_info_widget.dart';
import 'package:internship_practice/routes/router.gr.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.data();
                return Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileHeader(
                        buttonText: AppStrings.edit,
                        onPress: () {
                          context.router.push(
                            EditProfileRoute(
                              photoUrl: data!['photoUrl'],
                              username: data['username'],
                              instagram: data['instagram'],
                              location: data['location'],
                              age: data['age'].toString(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    ProfilePictureWidget(
                      profilePictureUrl: data!['photoUrl'],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    UserInfoWidget(
                      username: data['username'],
                      age: data['age'].toString(),
                      location: data['location'],
                      email: data['email'],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(
                  color: Colors.white,
                );
              } else {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
