import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontask/models/place_location.dart';
import 'package:ontask/screens/map_screen.dart';
import 'package:ontask/services/location_service.dart';

class LocationHomeScreen extends StatefulWidget {
  const LocationHomeScreen({super.key});

  @override
  State<LocationHomeScreen> createState() => _LocationHomeScreenState();
}

class _LocationHomeScreenState extends State<LocationHomeScreen> {
  LatLng? _locationData;
  final Location _location = Location();
  String _staticMapUrl = '';
  String _address = '';

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

  void setLocation(PlaceLocation placeLocation) {
    setState(() {
      _locationData = LatLng(placeLocation.latitude, placeLocation.longitude);
      _address = placeLocation.address;
      _staticMapUrl = LocationService.generateStaticMapUrl(
        latitude: placeLocation.latitude,
        longitude: placeLocation.longitude,
      );
    });
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
          if (_address.isNotEmpty) Text(_address),
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
              String address = await LocationService.getCoordinateAddress(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!);
              setState(() {
                _locationData = LatLng(
                  locationData.latitude!,
                  locationData.longitude!,
                );
                _address = address;
                _staticMapUrl = LocationService.generateStaticMapUrl(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                );
              });
            },
            child: const Text('Get location'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => MapScreen(
                  setLocationFn: setLocation,
                ),
              ),
            ),
            child: const Text('Open Map'),
          ),
        ],
      ),
    );
  }
}
