import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontask/services/location_service.dart';

import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.initialLocaion});
  final PlaceLocation initialLocaion;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation = LatLng(-6.1754, 106.8272);
  String _address = '';

  Future getUserLocation() async {
    LocationData? locationData = await LocationService.getUserLocation();
    if (locationData != null) {
      setLocation(
        LatLng(locationData.latitude!, locationData.longitude!),
      );
    }
  }

  Future setLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  void initState() {
    if (widget.initialLocaion.latitude == 0 &&
        widget.initialLocaion.longitude == 0) {
      getUserLocation();
    } else {
      setLocation(
        LatLng(widget.initialLocaion.latitude, widget.initialLocaion.longitude),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_address),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 15,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}
