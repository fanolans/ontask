import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ontask/models/place_location.dart';
import 'package:ontask/services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PlaceLocation _placeLocation = PlaceLocation(
    latitude: -7.4129736,
    longitude: 109.2756903,
  );

  void setLocation(LatLng position) async {
    String address = await LocationService.getCoordinateAddress(
        latitude: position.latitude, longitude: position.longitude);
    setState(() {
      _placeLocation = PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_placeLocation.address),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_placeLocation.latitude, _placeLocation.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('userLocaion'),
            position: LatLng(_placeLocation.latitude, _placeLocation.longitude),
          ),
        },
        onTap: setLocation,
      ),
    );
  }
}
