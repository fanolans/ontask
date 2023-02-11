import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ontask/services/location_service.dart';

class LocationHomeScreen extends StatefulWidget {
  const LocationHomeScreen({super.key});

  @override
  State<LocationHomeScreen> createState() => _LocationHomeScreenState();
}

class _LocationHomeScreenState extends State<LocationHomeScreen> {
  LocationData? _locationData;
  final Location _location = Location();
  String _staticMapUrl = '';

  @override
  void initState() {
    _location.requestService().then((serviceEnabled) {
      if (serviceEnabled) {
        _location.requestPermission().then((permissionStatus) {
          if (permissionStatus == PermissionStatus.granted) {
            _location.enableBackgroundMode(enable: true);
            _location.onLocationChanged.listen((locationData) {
              print(locationData.latitude);
              print(locationData.longitude);
            });
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Column(
        children: [
          if (_staticMapUrl.isNotEmpty) Image.network(_staticMapUrl),
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
                _staticMapUrl = LocationService.generateStaticMapUrl(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                );
              });
            },
            child: const Text('Get location'),
          ),
        ],
      ),
    );
  }
}
