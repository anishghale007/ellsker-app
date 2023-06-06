import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/call/presentation/bloc/call_bloc.dart';
import 'package:internship_practice/injection_container.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late CallBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<CallBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (_) => _bloc,
            child: BlocConsumer<CallBloc, CallState>(
              listener: (context, state) {
                if (state is CallSuccess) {
                  log("Success");
                } else if (state is CallError) {
                  log("Error");
                }
              },
              builder: (context, state) {
                if (state is CallInitial) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight / 2),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CallBloc>().add(
                                    const GetRtcTokenEvent(
                                      channelName: "test",
                                      role: "publisher",
                                      tokenType: "userAccount",
                                      uid: "10",
                                    ),
                                  );
                              // context.router.push(
                              //   MapRoute(
                              //     userLatitude: null,
                              //     userLongitude: null,
                              //     username: null,
                              //   ),
                              // );
                            },
                            child: const Text("Get Location"),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is CallError) {
                  return Center(
                    child: Text(state.errorMessage.toString()),
                  );
                } else if (state is CallSuccess) {
                  return Center(
                    child: Text(
                      state.videoCallEntity.rtcToken,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (state is CallLoading) {
                  return const CircularProgressIndicator();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
