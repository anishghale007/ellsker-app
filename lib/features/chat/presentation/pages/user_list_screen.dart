import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list_cubit.dart';
import 'package:internship_practice/ui_pages.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

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
                    "Users List",
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
                BlocBuilder<UserListCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (state is UserLoaded) {
                      log("Loaded");
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final data = state.users[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(kChatScreenPath);
                            },
                            child: SizedBox(
                              height: data.userId == currentUser ? 0 : 70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(data.photoUrl),
                                  radius: 25,
                                ),
                                title: Text(
                                  data.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is UserFailure) {
                      return const Text("Error");
                    } else {
                      log("Not Loaded");
                    }
                    return Container();
                  },
                ),
                // BlocBuilder<UserListBloc, UserListState>(
                //   builder: (context, state) {
                //     if (state is UserListLoading) {
                //       return const Center(
                //         child: CircularProgressIndicator(
                //           color: Colors.white,
                //         ),
                //       );
                //     } else if (state is UserListLoaded) {
                //       log("Loaded");
                //       return ListView.builder(
                //         shrinkWrap: true,
                //         scrollDirection: Axis.vertical,
                //         // physics: const NeverScrollableScrollPhysics(),
                //         itemCount: state.userList.length,
                //         itemBuilder: (context, index) {
                //           final data = state.userList[index];
                //           return Text(data.userName);
                //         },
                //       );
                //     } else if (state is UserListError) {
                //       return Text(state.errorMessage);
                //     } else {
                //       log("Not Loaded");
                //     }
                //     return Container();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
