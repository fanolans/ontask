import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const googleApiKey = 'AIzaSyBym3WxDcjYJRf5iqUcdeHh8MZbcBj4we4';

class LocationService {
  static Future<LocationData?> getUserLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        return null;
      }
    }
    return location.getLocation();
  }

  static String generateMapUrlImage({
    double? latitude,
    double? longitude,
  }) {
    if (latitude == null || longitude == null) return '';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude,key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      if (results['results'].lenghh > 0) {
        return results['results'][0]['formatted_address'];
      }
    }
    return '';
  }
}
