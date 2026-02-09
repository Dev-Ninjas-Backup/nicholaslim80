import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';

class PromoService {
  static Future<Map<String, dynamic>> applyPromo({
    required int orderId,
    required String promoCode,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final url =
          '${ApiEndPoint.baseUrl}/order/$orderId/apply-discount';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "promoCode": promoCode,
        }),
      );

      debugPrint(
          '✅ APPLY PROMO RESPONSE: ${response.statusCode}\n${response.body}');

      final decoded = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': decoded['success'] ?? false,
        'body': decoded,
      };
    } catch (e) {
      debugPrint('❌ PromoService.applyPromo error: $e');
      return {'statusCode': 500, 'success': false, 'body': {}};
    }
  }
}
