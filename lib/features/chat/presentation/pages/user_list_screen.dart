import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/common/widgets/search_bar_widget.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/chat/domain/entities/user_entity.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/user_list/user_list_cubit.dart';
import 'package:internship_practice/features/chat/presentation/widgets/user_list_tile_widget.dart';
import 'package:internship_practice/injection_container.dart';

class UserListScreen extends StatefulWidget implements AutoRouteWrapper {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ConversationBloc>(),
          child: this,
        ),
        BlocProvider(
          create: (context) => sl<UserListCubit>(),
          child: this,
        )
      ],
      child: this,
    );
  }
}

class _UserListScreenState extends State<UserListScreen> {
  late TextEditingController _searchController;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            AppStrings.usersList,
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
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
                    AppStrings.startAConversationWithAUser,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: SearchBarWidget(
                    hintText: AppStrings.searchByUsernameOrEmail,
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<List<UserEntity>>(
                  stream: context.read<UserListCubit>().getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.transparent,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data?[index];
                          if (data!.userName
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchText.toLowerCase()) ||
                              data.email
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchText.toLowerCase())) {
                            return UserListTileWidget(
                              data: data,
                              currentUser: currentUser,
                            );
                          } else if (searchText.isEmpty) {
                            return UserListTileWidget(
                              data: data,
                              currentUser: currentUser,
                            );
                          }
                          return Container();
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const LoadingWidget(
                        color: Colors.white,
                      );
                    } else {
                      return Container();
                    }
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
