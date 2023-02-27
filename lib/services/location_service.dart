const googleApiKey = 'AIzaSyBym3WxDcjYJRf5iqUcdeHh8MZbcBj4we4';

class LocationService {
  static String generateMapUrlImage({
    double? latitude,
    double? longitude,
  }) {
    if (latitude == null || longitude == null) return '';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
  }
}
