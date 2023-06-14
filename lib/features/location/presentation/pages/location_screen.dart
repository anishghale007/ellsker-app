import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/routes/router.gr.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

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
                    onPressed: () async {
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
