import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/wallet/loyalty_and_rewards/widget/redeem_bottom_shit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoyaltyAndRewardsController extends GetxController {
  RxInt points = 0.obs;
  RxDouble dollarValue = 0.0.obs;
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;

  int totalPointsForBasePrice = 120;
  double basePrice = 0.0;

  /// ================= AUTH HEADER =================
  Future<Map<String, String>> _getAuthHeader() async {
    final token = await SharedPreferencesHelper.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  /// ================= LOAD USER POINTS =================
  Future<void> loadUserPoints() async {
    try {
      final headers = await _getAuthHeader();

      final response = await http.get(
        Uri.parse(ApiEndPoint.profile),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];

        points.value =
            int.tryParse(data?['reward_points']?.toString() ?? '0') ?? 0;

        calculateDollarValue();
      }
    } catch (e) {
      debugPrint("Points load error: $e");
    }
  }

  /// ================= FETCH BASE PRICE =================
  Future<void> fetchCoinBasePrice() async {
    try {
      final headers = await _getAuthHeader();

      final response = await http.get(
        Uri.parse(ApiEndPoint.coinBasePrice),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          basePrice = double.tryParse(data['data']?.toString() ?? '0') ?? 0.0;

          calculateDollarValue();
        }
      }
    } catch (e) {
      debugPrint("Base price error: $e");
    }
  }

  /// ================= CALCULATE VALUE =================
  void calculateDollarValue() {
    if (totalPointsForBasePrice > 0 && basePrice > 0) {
      dollarValue.value = (points.value / totalPointsForBasePrice) * basePrice;
    } else {
      dollarValue.value = 0.0;
    }
  }

  /// ================= REDEEM =================
  Future<void> redeemPoints(int pointsToRedeem) async {
    if (pointsToRedeem <= 0) {
      EasyLoading.showInfo('No points to redeem');
      return;
    }

    try {
      EasyLoading.show(status: 'Redeeming...');

      final headers = await _getAuthHeader();

      final response = await http.post(
        Uri.parse(ApiEndPoint.redeemCoin),
        headers: headers,
        body: jsonEncode({'points': pointsToRedeem}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          points.value -= pointsToRedeem;
          calculateDollarValue();
          EasyLoading.showSuccess(data['message'] ?? 'Points redeemed!');
        } else {
          EasyLoading.showError(data['message'] ?? 'Redeem failed');
        }
      } else {
        EasyLoading.showError('Error ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.showError('Redeem error');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// ================= UI METHODS =================
  void onBack() => Get.back();

  void showRedeemBottomSheet() {
    Get.bottomSheet(
      RedeemBottomSheet(
        onRedeem: () {
          Get.back();
          redeemPoints(points.value);
        },
        onCancel: () => Get.back(),
      ),
      isScrollControlled: true,
    );
  }

  void onInfoTap() {
    EasyLoading.showInfo('Loyalty & Rewards Information');
  }

  @override
  void onInit() {
    super.onInit();
    loadUserPoints();
    fetchCoinBasePrice();
  }
}
