import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';

class StripeService {
  /// Fetch Stripe credentials (public key and secret key)
  static Future<Map<String, dynamic>> getStripeCredentials() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse(ApiEndPoint.stripeCredentials),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('✅ STRIPE CREDENTIALS RESPONSE: ${response.statusCode}\n${response.body}');

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ StripeService.getStripeCredentials error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }

  /// Place order with payment method ID
  static Future<Map<String, dynamic>> placeOrder({
    required int orderId,
    required String paymentMethodId,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final url = Uri.parse(
        ApiEndPoint.placeOrder.replaceAll('{orderId}', orderId.toString())
      );

      final body = {
        'paymentMethod': 'ONLINE_PAY',
        'paymentMethodId': paymentMethodId,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('✅ PLACE ORDER RESPONSE: ${response.statusCode}\n${response.body}');

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ StripeService.placeOrder error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }
}
