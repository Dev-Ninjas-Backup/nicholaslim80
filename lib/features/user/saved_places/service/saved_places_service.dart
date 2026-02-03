import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;
import '../model/place_model.dart';

class SavedPlacesService {
  /// Uses the global API base so it works on both emulator and real devices.
  final String _baseUrl = ApiEndPoint.baseUrl;

  /// Fetch all saved destinations for the authenticated user.
  Future<List<PlaceModel>> getPlaces() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing access token');
    }

    final uri = Uri.parse('${ApiEndPoint.getDestination}');
    print('DEBUG SavedPlacesService.getPlaces -> GET $uri');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 12));

    print(
      'DEBUG SavedPlacesService.getPlaces -> status: ${response.statusCode}, body: ${response.body}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final dynamic dataNode = body['data'];

      // API sometimes wraps list differently; handle both.
      final List<dynamic> dataList = switch (dataNode) {
        List<dynamic> list => list,
        Map<String, dynamic> map when map['data'] is List<dynamic> =>
          List<dynamic>.from(map['data'] as List),
        _ => <dynamic>[],
      };

      return dataList
          .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load places (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<void> addPlace({required String name, required String address}) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing access token');
    }

    final uri = Uri.parse(ApiEndPoint.createDestination);
    final response = await http
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "address": address,
            "contact_name": name,
            "type": "SENDER",
            "latitude": 23.82,
            "longitude": 90.425,
          }),
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Add place failed (${response.statusCode})');
    }
  }

  Future<void> deletePlace(int id) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing access token');
    }

    final uri = Uri.parse('$_baseUrl/destination/$id');
    final response = await http
        .delete(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Delete failed (${response.statusCode})');
    }
  }
}
