import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internship_practice/features/location/presentation/pages/map_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    LocationPermission? locationPermission;
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
                      locationPermission = await Geolocator.requestPermission();
                      if (locationPermission == LocationPermission.denied) {
                        locationPermission =
                            await Geolocator.requestPermission();
                      } else if (locationPermission ==
                          LocationPermission.deniedForever) {
                        await Geolocator.openAppSettings();
                      } else if (locationPermission ==
                              LocationPermission.always ||
                          locationPermission == LocationPermission.whileInUse) {
                        final response = await Geolocator.getCurrentPosition();
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapScreen(
                                  // latitude: response.latitude,
                                  // longitude: response.longitude,
                                  ),
                            ),
                          );
                        }
                      }
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
