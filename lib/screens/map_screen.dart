import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontask/services/location_service.dart';

import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.initialLocaion,
    required this.setLocationFn,
  });
  final PlaceLocation initialLocaion;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation = LatLng(-6.1754, 106.8272);
  String _address = '';
  late GoogleMapController _googleMapController;

  Future getUserLocation() async {
    LocationData? locationData = await LocationService.getUserLocation();
    if (locationData != null) {
      setLocation(
        LatLng(locationData.latitude!, locationData.longitude!),
        moveCamera: true,
      );
    }
  }

  Future setLocation(LatLng position, {bool moveCamera = false}) async {
    String tempAddress = await LocationService.getPlaceAddress(
      position.latitude,
      position.longitude,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    if (moveCamera) {
      _googleMapController.moveCamera(CameraUpdate.newLatLng(position));
    }

    setState(() {
      _pickedLocation = position;
      _address = tempAddress;
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
        moveCamera: true,
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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('PlaceLocation'),
                position: _pickedLocation,
              ),
            },
            onMapCreated: (GoogleMapController googleMapController) {
              _googleMapController = googleMapController;
            },
            onTap: setLocation,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 0,
            right: 50,
            left: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.setLocationFn(
                  PlaceLocation(
                      latitude: _pickedLocation.latitude,
                      longitude: _pickedLocation.longitude,
                      address: _address),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Set Lokasi'),
            ),
          ),
        ],
      ),
    );
  }
}
