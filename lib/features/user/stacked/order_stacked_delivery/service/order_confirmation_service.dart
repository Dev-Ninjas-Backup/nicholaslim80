import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderConfirmationService {
  /// Get order details by order ID
  static Future<Map<String, dynamic>> getOrder(int orderId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final url = ApiEndPoint.getOrder.replaceAll('{orderId}', orderId.toString());
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('✅ GET ORDER RESPONSE: ${response.statusCode}\n${response.body}');

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ OrderConfirmationService.getOrder error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }

  /// Get user profile to get coin balance
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(ApiEndPoint.getUserProfile),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('✅ GET USER PROFILE RESPONSE: ${response.statusCode}\n${response.body}');

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ OrderConfirmationService.getUserProfile error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }
}
