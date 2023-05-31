import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/routes/router.gr.dart';
import 'package:record/record.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isRecording = false;
  final record = Record();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 2),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.push(
                        MapRoute(
                          userLatitude: null,
                          userLongitude: null,
                          username: null,
                        ),
                      );
                    },
                    child: const Text("Get Location"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
