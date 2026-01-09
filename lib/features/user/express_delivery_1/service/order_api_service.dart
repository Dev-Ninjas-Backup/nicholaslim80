import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:http/http.dart' as http;

class OrderService {

  static const String createOrder = '${ApiEndPoint.baseUrl}/order/indivitual';

  static Future<http.Response> createOrderApi({
    required Map<String, dynamic> body,
    required String token,
  }) async {
    return await http.post(
      Uri.parse(createOrder),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
