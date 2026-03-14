import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show get;

class UserProfileController extends GetxController {
  final userName = 'Good Morning!'.obs;
  final walletBalance = 0.0.obs;
  final availablePoints = 0.obs;

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(ApiEndPoint.profile),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          _updateProfileData(data);
        }
      }
    } catch (e) {
      debugPrint("PROFILE ERROR: $e");
    }
  }

  void _updateProfileData(Map<String, dynamic> data) {
    userName.value = "${_getGreeting()}, ${data['username'] ?? ''}";
    walletBalance.value = double.tryParse(data['currentWalletBalance'].toString()) ?? 0;
    availablePoints.value = int.tryParse(data['current_coin_balance'].toString()) ?? 0;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning!";
    if (hour < 17) return "Good Afternoon!";
    if (hour < 22) return "Good Evening!";
    return "Good Night!";
  }
}