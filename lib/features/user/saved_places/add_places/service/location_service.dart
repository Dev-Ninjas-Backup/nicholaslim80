import 'dart:convert';
import 'package:ZipBee/features/user/google_map/widget/consts.dart';
import 'package:http/http.dart' as http;

class LocationService {
  // ১. টাইপ করার সময় সাজেশন আনার জন্য
  static Future<List<dynamic>> getAutocomplete(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$GoogleMapAPIKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['predictions'];
    } else {
      return [];
    }
  }

  // ২. সিলেক্ট করার পর Lat, Lng বের করার জন্য
  static Future<Map<String, double>?> getPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GoogleMapAPIKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      return {
        'lat': location['lat'] as double,
        'lng': location['lng'] as double,
      };
    }
    return null;
  }
}