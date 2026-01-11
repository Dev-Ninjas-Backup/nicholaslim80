import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderService {
  /// Create an individual order. Returns parsed response on success or a
  /// map with statusCode and body on error.
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> body) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      debugPrint('OrderService.createOrder REQUEST -> ${ApiEndPoint.orderCreate} body: $body');

      final response = await http.post(
        Uri.parse(ApiEndPoint.orderCreate),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('OrderService.createOrder RESPONSE -> ${response.statusCode} ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('OrderService.createOrder error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }

  /// Get order details by order id.
  static Future<Map<String, dynamic>> getOrder(int id) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse('${ApiEndPoint.baseUrl}/order/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('GET ORDER RESPONSE: ${response.statusCode} ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('OrderService.getOrder error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }

  /// Place an existing order (finalize it). Endpoint: POST /order/{id}/place
  static Future<Map<String, dynamic>> placeOrder(int id, Map<String, dynamic> body) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.post(
        Uri.parse('${ApiEndPoint.baseUrl}/order/$id/place'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('PLACE ORDER RESPONSE: ${response.statusCode} ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('OrderService.placeOrder error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }
}
