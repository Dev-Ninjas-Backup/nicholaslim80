import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class NotifyRider {
  static Future<Map<String, dynamic>> notifyRider({
    required String orderId,
    required bool notifyRider,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = ApiEndPoint.notifyOrder.replaceAll('{orderId}', orderId);

      final response = await http.post(
        Uri.parse(url), 
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token', 
        }, 
        body: jsonEncode({
          "notify_rider": notifyRider
        })
      );
      
      debugPrint('✅ NOTIFY RIDER RESPONSE: ${response.statusCode}\n${response.body}');
      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded
      };
    } catch (e) {
      debugPrint("Error notifying rider: $e"); 
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }
}