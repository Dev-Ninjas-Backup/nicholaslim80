import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/order/model/order_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class OrderController extends GetxController {
  final RxInt selectOrderListIndex = 0.obs;
  final RxBool isLoading = false.obs;

  final orderTabs = ["Active", "Completed", "Cancelled"];

  final RxList<OrderModel> orderList = <OrderModel>[].obs;

  get totalAmount => null;

  final RxBool redeemCoins = false.obs;

  void toggleRedeemCoins(bool? value) => redeemCoins.value = value ?? false;

  get favoriteRiders => null;

  final RxBool toggleFavoriteRiders = false.obs;

  get orderNumber => null;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Authentication token missing");
        return;
      }

      final status = orderTabs[selectOrderListIndex.value].toLowerCase();

      final uri = Uri.parse("${ApiEndPoint.order}?status=$status");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List data = decoded['data'] ?? [];
        orderList.assignAll(data.map((e) => OrderModel.fromJson(e)).toList());
      } else {
        Get.snackbar("Error", "Failed to load orders");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
