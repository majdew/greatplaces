import 'dart:convert';

import 'package:http/http.dart' as http;

//const GOOGLE_API_KEY = 'AIzaSyCyBToaaKJAoTl6Wa6ckuPP0QwTe34-6A4';
const GOOGLE_API_KEY = "AIzaSyAeZd4TEB-cgKfpRSy6QmcQANKAQc-I5X0";

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY";

    print(url);
    final response = await http.get(url);
    print(json.decode(response.body));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
