import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/location/presentation/pages/map_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapScreen(),
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
