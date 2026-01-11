import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:http/http.dart' as http;

class OrderService {

  static const String createOrder = '${ApiEndPoint.orderCreate}';

  static Future<http.Response> createOrderApi({
    required Map<String, dynamic> body,
    required String token,
  }) async {
    debugPrint('Express OrderService.request -> $createOrder body: $body');
    final resp = await http.post(
      Uri.parse(createOrder),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    debugPrint('Express OrderService.response -> ${resp.statusCode} ${resp.body}');
    return resp;
  }
}
