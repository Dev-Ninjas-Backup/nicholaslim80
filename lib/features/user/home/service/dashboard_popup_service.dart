import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DashboardPopupService {
  static Future<Map<String, dynamic>> fetchPopups () async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = "${ApiEndPoint.baseUrl}/dashboard-popup";

      final response = await http.get(
        Uri.parse(url), 
        headers: {
          'accept': '*/*', 
          if (token != null) 'Authorization': 'Bearer $token', 
        }, 
      );
      debugPrint('🔍 POPUP API RESPONSE: ${response.body}'); 
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('❌ DashboardPopupService Error: $e');
      return {'success': false, 'data': []};
    }
  }
}