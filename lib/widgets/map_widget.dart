import 'package:flutter/material.dart';
import 'package:ontask/models/place_location.dart';
import 'package:ontask/screens/map_screen.dart';

import '../services/location_service.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.placeLocation,
    required this.setLocationFn,
  });
  final PlaceLocation placeLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  Widget build(BuildContext context) {
    String previewMapUrlImage = LocationService.generateMapUrlImage(
      latitude: placeLocation.latitude,
      longitude: placeLocation.longitude,
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => MapScreen(
              initialLocaion: placeLocation,
              setLocationFn: setLocationFn,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: previewMapUrlImage.isEmpty
            ? const Center(
                child: Text('Tap untuk menambahkan lokasi'),
              )
            : Image.network(previewMapUrlImage),
      ),
    );
  }
}
