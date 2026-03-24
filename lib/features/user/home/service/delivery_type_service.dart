import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;

class DeliveryTypeService {
  static Future<Map<String, dynamic>> getDeliveryTypes() async {
    final String url = ApiEndPoint.deliveryTypes;
    final token = await SharedPreferencesHelper.getAccessToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token'
        },
      );
      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      return {'statusCode': 500, 'body': null};
    }
  }
}