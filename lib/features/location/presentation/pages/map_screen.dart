import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> marker = {};

  void _onMapCreate(GoogleMapController controller) {
    setState(() {
      marker.add(Marker(
        markerId: const MarkerId('id_1'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: const InfoWindow(
            title: 'Current Location', snippet: 'You are here'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen"),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        markers: marker,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.latitude,
            widget.longitude,
          ),
          zoom: 14.4746,
        ),
        onMapCreated: (controller) {
          _controller.complete(controller);
          _onMapCreate(controller);
        },
      ),
    );
  }
}
