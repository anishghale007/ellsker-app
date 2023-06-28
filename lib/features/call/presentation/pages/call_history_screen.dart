import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/loading_widget.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/call/presentation/bloc/call/call_bloc.dart';
import 'package:internship_practice/features/call/presentation/widgets/call_log_list_tile_widget.dart';
import 'package:internship_practice/injection_container.dart';

class CallHistoryScreen extends StatelessWidget {
  final String userId;

  const CallHistoryScreen({
    super.key,
    required this.userId,
  });

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
            AppStrings.callHistory,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Text(
                    "Recent Calls",
                    style: GoogleFonts.sourceSansPro(
                      color: ColorUtil.kTertiaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                BlocBuilder<CallBloc, CallState>(
                  bloc: sl<CallBloc>()
                    ..add(GetAllCallLogsEvent(userId: userId)),
                  builder: (context, state) {
                    if (state is CallLoading) {
                      return const LoadingWidget(
                        color: Colors.white,
                      );
                    } else if (state is CallError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else if (state is CallLogsLoaded) {
                      return ListView.builder(
                        itemCount: state.callLogsList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = state.callLogsList[index];
                          final startTime = DateTime.parse(data.callStartTime);
                          final endTime = DateTime.parse(data.callStartTime);
                          final callTime =
                              startTime.difference(endTime).inMinutes;
                          return CallLogListTileWidget(
                            data: data,
                            currentUser: currentUser,
                            callTime: callTime,
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
