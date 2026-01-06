import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YourRewardsService {
  static Future<Map<String, dynamic>> fetchBasePrice() async {
    try {
      final response = await http.get(Uri.parse(ApiEndPoint.coinBasePrice));
      debugPrint('BASE PRICE RESPONSE: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('YourRewardsService.fetchBasePrice error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }

  static Future<Map<String, dynamic>> redeemCoin({required int coin}) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = Uri.parse('${ApiEndPoint.redeemCoin}?coin=$coin');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      debugPrint('REDEEM COIN REQUEST: $url');
      debugPrint('REDEEM COIN RESPONSE: ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('YourRewardsService.redeemCoin error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }
}
