import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;

class AdsService {
  static Future<List<Map<String, dynamic>>> fetchAds() async {
    final token = await SharedPreferencesHelper.getAccessToken();

    final response = await http.get(
      Uri.parse(ApiEndPoint.homePageAd),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List list = decoded['data']['data'];
      return List<Map<String, dynamic>>.from(list);
    } else {
      throw Exception("Failed to load ads");
    }
  }
}
