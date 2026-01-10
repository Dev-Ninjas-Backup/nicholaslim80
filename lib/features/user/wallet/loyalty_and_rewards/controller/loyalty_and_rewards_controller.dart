import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/wallet/loyalty_and_rewards/widget/redeem_bottom_shit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoyaltyAndRewardsController extends GetxController {
  RxInt points = 0.obs; // User's current points
  RxDouble dollarValue = 0.0.obs; // Calculated dollar value
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;

  int totalPointsForBasePrice = 120; // Example: 120 points = full base price
  double basePrice = 0.0; // Base price from API

  /// ======================
  /// Helper to get Auth Header
  /// ======================
  Future<Map<String, String>> _getAuthHeader() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    print('Auth Token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  /// ======================
  /// API Methods
  /// ======================

  /// Fetch base coin price
  Future<void> fetchCoinBasePrice() async {
    try {
      EasyLoading.show(status: 'Loading base price...');
      final headers = await _getAuthHeader();
      final response = await http.get(
        Uri.parse(ApiEndPoint.coinBasePrice),
        headers: headers,
      );

      print('fetchCoinBasePrice response: ${response.statusCode}');
      print('fetchCoinBasePrice body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          basePrice = (data['data'] ?? 0).toDouble();
          print('Base price fetched: \$${basePrice}');

          // Calculate dollar value based on points
          if (points.value > 0) {
            dollarValue.value =
                (points.value / totalPointsForBasePrice) * basePrice;
          }
          print('Dollar value calculated: \$${dollarValue.value}');
        } else {
          EasyLoading.showError(
            data['message'] ?? 'Failed to fetch base price',
          );
        }
      } else {
        EasyLoading.showError('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('fetchCoinBasePrice error: $e');
      EasyLoading.showError('Error fetching base price');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Redeem points
  Future<void> redeemPoints(int pointsToRedeem) async {
    if (pointsToRedeem <= 0) {
      EasyLoading.showInfo('No points to redeem');
      return;
    }

    try {
      EasyLoading.show(status: 'Redeeming points...');
      final headers = await _getAuthHeader();
      final response = await http.post(
        Uri.parse(ApiEndPoint.redeemCoin),
        headers: headers,
        body: jsonEncode({'points': pointsToRedeem}),
      );

      print('redeemPoints response: ${response.statusCode}');
      print('redeemPoints body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          points.value -= pointsToRedeem;
          // Recalculate dollar value after redeem
          dollarValue.value =
              (points.value / totalPointsForBasePrice) * basePrice;
          EasyLoading.showSuccess(data['message'] ?? 'Points redeemed!');
          print('Points after redeem: ${points.value}');
          print('Dollar value after redeem: \$${dollarValue.value}');
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to redeem points');
        }
      } else {
        EasyLoading.showError('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('redeemPoints error: $e');
      EasyLoading.showError('Error redeeming points');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Send referral code
  Future<void> referLoyalty(String referralCode) async {
    try {
      EasyLoading.show(status: 'Sending referral...');
      final headers = await _getAuthHeader();
      final response = await http.post(
        Uri.parse(ApiEndPoint.referLoyalty),
        headers: headers,
        body: jsonEncode({'referralCode': referralCode}),
      );

      print('referLoyalty response: ${response.statusCode}');
      print('referLoyalty body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          EasyLoading.showSuccess(data['message'] ?? 'Referral sent!');
          print('Referral sent for code: $referralCode');
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to send referral');
        }
      } else {
        EasyLoading.showError('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('referLoyalty error: $e');
      EasyLoading.showError('Error sending referral');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// ======================
  /// UI Methods
  /// ======================

  void onBack() => Get.back();

  void showRedeemBottomSheet() {
    Get.bottomSheet(
      RedeemBottomSheet(
        onRedeem: () {
          Get.back();
          if (points.value > 0) {
            redeemPoints(points.value); // Redeem all points
          } else {
            EasyLoading.showInfo('No points available to redeem');
          }
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
    // Example: fetch base price first, then later you can fetch points if API exists
    fetchCoinBasePrice();
  }
}
