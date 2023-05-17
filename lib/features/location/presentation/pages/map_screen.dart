import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internship_practice/colors_utils.dart';

class MapScreen extends StatefulWidget {
  final double? userLatitude;
  final double? userLongitude;
  final String? username;

  const MapScreen({
    super.key,
    this.username,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationPermission? locationPermission;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double? myLatitude;
  double? myLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Set<Marker> marker = {};

  void _onMapCreate(GoogleMapController controller) {
    setState(() {
      marker.add(
        Marker(
          markerId: const MarkerId('id_1'),
          position: LatLng(myLatitude!, myLongitude!),
          infoWindow:
              const InfoWindow(title: 'My Location', snippet: 'You are here'),
        ),
      );
      widget.userLatitude != null
          ? marker.add(
              Marker(
                markerId: const MarkerId('id_2'),
                position: LatLng(widget.userLatitude!, widget.userLongitude!),
                infoWindow: InfoWindow(
                    title: '${widget.username} Location',
                    snippet: '${widget.username} is here'),
              ),
            )
          : null;
    });
  }

  _getCurrentLocation() async {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    } else if (locationPermission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      final response = await Geolocator.getCurrentPosition();
      setState(() {
        myLatitude = response.latitude;
        myLongitude = response.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen"),
        centerTitle: true,
        backgroundColor: ColorUtil.kPrimaryColor,
      ),
      body: myLatitude != null && myLongitude != null
          ? GoogleMap(
              mapType: MapType.normal,
              markers: marker,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.userLatitude ?? myLatitude!,
                  widget.userLongitude ?? myLongitude!,
                ),
                zoom: 14.4746,
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
                _onMapCreate(controller);
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtil.kPrimaryColor,
        child: const Icon(Icons.gps_fixed),
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(myLatitude!, myLongitude!),
                zoom: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
