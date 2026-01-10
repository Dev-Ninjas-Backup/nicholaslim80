import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderControllerExpress extends GetxController {
  RxBool redeemCoins = false.obs;
  RxBool favoriteRiders = false.obs;
  RxBool isLoading = false.obs;
  RxDouble totalAmount = 0.0.obs;

  /// Toggle redeem coins
  void toggleRedeemCoins(bool value) {
    redeemCoins.value = value;
    redeemCoinApi();
  }

  /// Toggle favourite riders option
  void toggleFavoriteRiders(bool value) {
    favoriteRiders.value = value;
  }

  /// Call API to estimate total order amount
  Future<void> redeemCoinApi() async {
    try {
      isLoading.value = true;

      final token = await SharedPreferencesHelper.getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Session Expired", "Please login again");
        return;
      }

      final body = {"redeem_coin": redeemCoins.value};
      print("📦 REQUEST BODY: $body");

      final response = await http.post(
        Uri.parse(ApiEndPoint.redeemCoin),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("📡 STATUS CODE: ${response.statusCode}");
      print("📨 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalAmount.value =
            double.tryParse(data['data']['total_amount'].toString()) ?? 0.0;
      } else {
        Get.snackbar("API Error", response.body.toString());
      }
    } catch (e) {
      print("❌ ERROR: $e");
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
