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
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: previewMapUrlImage.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Tap untuk menambahkan lokasi'),
                ),
              )
            : Stack(
                children: [
                  Image.network(previewMapUrlImage),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        setLocationFn(
                          PlaceLocation(
                            latitude: 0.0,
                            longitude: 0.0,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
