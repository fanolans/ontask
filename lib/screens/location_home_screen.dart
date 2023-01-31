import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationHomeScreen extends StatefulWidget {
  const LocationHomeScreen({super.key});

  @override
  State<LocationHomeScreen> createState() => _LocationHomeScreenState();
}

class _LocationHomeScreenState extends State<LocationHomeScreen> {
  LocationData? _locationData;
  final Location _location = Location();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Column(
        children: [
          if (_locationData != null)
            Text('${_locationData!.latitude}, ${_locationData!.longitude}'),
          ElevatedButton(
            onPressed: () async {
              bool serviceEnabled = await _location.serviceEnabled();
              if (!serviceEnabled) {
                serviceEnabled = await _location.requestService();
                if (!serviceEnabled) {
                  return;
                }
              }
              PermissionStatus permissionStatus =
                  await _location.hasPermission();
              if (permissionStatus == PermissionStatus.denied) {
                permissionStatus = await _location.requestPermission();
                if (permissionStatus == PermissionStatus.denied) {
                  return;
                }
              }
              final locationData = await _location.getLocation();
              print(locationData.latitude);
              print(locationData.longitude);
              setState(() {
                _locationData = locationData;
              });
            },
            child: const Text('Get location'),
          ),
        ],
      ),
    );
  }
}
