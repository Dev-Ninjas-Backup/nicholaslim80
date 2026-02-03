import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PriorityOrderService {
  static Future<Map<String, dynamic>> makePriorityOrder({
    required int orderId,
    required double amount,
    String payType = "WALLET",
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      
      // URL: https://api.zipbee.sg/api/v1/order/{orderId}/priority-order
      final url = "${ApiEndPoint.baseUrl}/order/$orderId/priority-order";

      // Convert amount to integer (multiply by 100 if you need cents, or just round to int)
      final amountAsInt = amount.toInt();

      final Map<String, dynamic> requestBody = {
        "payType": payType,
        "amount": amountAsInt,
      };

      debugPrint('🚀 PRIORITY ORDER REQUEST URL: $url');
      debugPrint('📦 REQUEST BODY: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('✅ PRIORITY ORDER RESPONSE CODE: ${response.statusCode}');
      debugPrint('📄 RESPONSE BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      // Handle message as either String or List
      String errorMessage = '';
      if (decoded['message'] is List) {
        errorMessage = (decoded['message'] as List).isNotEmpty 
            ? decoded['message'][0].toString() 
            : 'Unknown error';
      } else {
        errorMessage = decoded['message']?.toString() ?? 'Unknown error';
      }

      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'message': errorMessage,
        'body': decoded
      };
    } catch (e) {
      debugPrint('❌ PriorityOrderService Error: $e');
      return {
        'statusCode': 500,
        'success': false,
        'message': e.toString(),
        'body': {}
      };
    }
  }
}