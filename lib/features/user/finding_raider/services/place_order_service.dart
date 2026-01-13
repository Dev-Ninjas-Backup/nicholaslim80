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

      if (token == null || token.isEmpty) {
        print('❌ Token not found');
        return false;
      }

      final uri =
          Uri.parse('https://api.zipbee.sg/api/v1/order/$orderId/place');

      /// 🔹 Build request body safely
      final Map<String, dynamic> body = {
        "paymentMethod": paymentMethod,
      };

      /// 🔹 Only send paymentMethodId if backend really needs it
      if (paymentMethodId.isNotEmpty) {
        body["paymentMethodId"] = paymentMethodId;
      }

      print('📡 PLACE ORDER BODY: $body');

      final response = await http.post(
        uri,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('🔹 STATUS: ${response.statusCode}');
      print('📝 RESPONSE: ${response.body}');

      /// 🔹 Decode response safely
      final decoded = jsonDecode(response.body);

      /// ✅ SUCCESS ONLY IF BACKEND SAYS success:true
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decoded['success'] == true) {
        print('✅ Order placed successfully');
        return true;
      }

      /// ❌ Backend-handled failure
      print('❌ Order failed: ${decoded['message']}');
      return false;
    } catch (e) {
      print('❌ Exception while placing order: $e');
      return false;
    }
  }
}
