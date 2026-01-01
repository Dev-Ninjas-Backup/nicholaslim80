import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import '../model/place_model.dart';

class SavedPlacesService {
  final String baseUrl = 'http://10.0.2.2:3000/api/v1';

  Future<List<PlaceModel>> getPlaces() async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final response = await http
        .get(
          Uri.parse('$baseUrl/destination'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => PlaceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> addPlace({required String name, required String address}) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final response = await http
        .post(
          Uri.parse('$baseUrl/destination'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "address": address,
            "contact_name": name,
            "type": "SENDER",
            "latitude": 23.82,
            "longitude": 90.425,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Add place failed');
    }
  }

  Future<void> deletePlace(int id) async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final response = await http
        .delete(
          Uri.parse('$baseUrl/destination/$id'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Delete failed');
    }
  }
}
