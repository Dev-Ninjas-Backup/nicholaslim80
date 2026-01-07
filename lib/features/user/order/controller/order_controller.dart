import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/order_model.dart';

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

  // Pagination
  int page = 1;
  final int limit = 20;

  // Status mapping
  String get selectedStatus {
    switch (selectOrderListIndex.value) {
      case 0:
        return "ONGOING";
      case 1:
        return "COMPLETED";
      case 2:
        return "CANCELLED";
      default:
        return "ONGOING";
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders(isRefresh: true);
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;

    if (isRefresh) {
      page = 1;
      orderList.clear();
    }

    isLoading.value = true;

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      final uri = Uri.parse(
        "${ApiEndPoint.order}"
        "?status=$selectedStatus"
        "&page=$page"
        "&limit=$limit",
      );

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      debugPrint("Order Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data']['data'];

        orderList.assignAll(
          list.map((e) {
            // inject status for UI
            e['status'] = selectedStatus;
            return OrderModel.fromJson(e);
          }).toList(),
        );

        page++;
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
