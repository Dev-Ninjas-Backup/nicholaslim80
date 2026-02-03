import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/shared_prefference_service/shared_pref.dart';

class UserMyWalletController extends GetxController {
  var selectFundsOrRedeen = 0.obs;
  var isLoading = false.obs;

  /// Stripe wallet balance
  RxDouble currentBalance = 0.0.obs;

  /// Wallet history (NO MODEL)
  var recentTransactionList = <Map<String, dynamic>>[].obs;

  String? userId;

  @override
  void onInit() {
    super.onInit();
    loadProfileAndWallet();
  }

  /// ================= PROFILE =================
  Future<void> loadProfileAndWallet() async {
    try {
      isLoading.value = true;

      final token = await SharedPreferencesHelper.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndPoint.profile),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        userId = body['data']['id'].toString();

        /// ✅ Save userId for global use
        await SharedPreferencesHelper.saveUserId(userId!);

        /// ✅ Stripe balance only
        currentBalance.value =
            double.tryParse(body['data']['currentWalletBalance'].toString()) ??
            0.0;

        await loadWalletHistory();
      }
    } catch (e) {
      print("Profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= WALLET HISTORY =================
  Future<void> loadWalletHistory() async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      if (token == null || userId == null) return;

      final response = await http.get(
        Uri.parse("${ApiEndPoint.walletHistory}/$userId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        recentTransactionList.clear();

        for (var item in body['data']) {
          recentTransactionList.add({
            "title": item['type'] ?? "Transaction",
            "orderId": item['reference'] ?? "",
            "amount": item['amount'].toString(),
          });
        }
      }
    } catch (e) {
      print("Wallet history error: $e");
    }
  }
}
