import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';



class ReferAndEarnService {
  static Future<Map<String, dynamic>> fetchReferralData() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(ApiEndPoint.userMe),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('USER /me RESPONSE: ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('ReferAndEarnService error: $e');
      return {
        'statusCode': 500,
        'body': {},
      };
    }
  }
}
