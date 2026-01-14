import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';

class PlaceOrderService {
  static Future<bool> placeOrder({
    required int orderId,
    required String paymentMethod,
    required String paymentMethodId,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return false;

      final uri =
          Uri.parse('https://api.zipbee.sg/api/v1/order/$orderId/place');

      final body = {
        "paymentMethod": paymentMethod,
        if (paymentMethodId.isNotEmpty)
          "paymentMethodId": paymentMethodId,
      };

      print('📡 PLACE ORDER BODY: $body');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('🔹 STATUS: ${response.statusCode}');
      print('📝 RESPONSE: ${response.body}');

      final decoded = jsonDecode(response.body);

      /// ✅ REAL SUCCESS CHECK
      return decoded['success'] == true;
    } catch (e) {
      print('❌ PLACE ORDER ERROR: $e');
      return false;
    }
  }
}
