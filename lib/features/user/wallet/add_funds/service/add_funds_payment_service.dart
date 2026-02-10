import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';

/// Service for wallet add funds payment
class AddFundsPaymentService {
  /// Add money to wallet and get client secret for Stripe
  static Future<Map<String, dynamic>> addMoney({
    required double amount,
    required String currency,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final url = Uri.parse(ApiEndPoint.addMoney);

      final body = {
        'amount': amount,
        // 'amount': 5000,
        'currency': currency,
        'orderId': null, // Optional: can be empty for wallet top-up'',
        'payType': 'ONLINE_PAY',
        'type': 'ADD_MONEY',
      };

      debugPrint('➡️ Add Money to Wallet POST body: $body and URL: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint(
        '✅ ADD MONEY RESPONSE: ${response.statusCode}\n${response.body}',
      );

      final decoded = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ AddFundsPaymentService.addMoneyToWallet error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }
}
