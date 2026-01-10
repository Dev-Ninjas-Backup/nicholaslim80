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

  // ✅ sender name from profile
  String senderName = "Collect from";

  // ---------------- STATUS ----------------
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

  // To track if all pages loaded
  final RxBool allLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchOrders(isRefresh: true);
  }

  // =================================================
  // PROFILE API (ONLY FOR USER NAME)
  // =================================================
  Future<void> fetchProfile() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(ApiEndPoint.profile),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        senderName = decoded['data']['username'] ?? "Collect from";
        debugPrint("Profile fetched: $senderName");
      }
    } catch (e) {
      debugPrint("Profile error: $e");
    }
  }

  // =================================================
  // ORDERS
  // =================================================
  Future<void> fetchOrders({bool isRefresh = false}) async {
    // ✅ Allow fetch for first page even if allLoaded is true
    if (isLoading.value) return;

    if (isRefresh) {
      page = 1;
      orderList.clear();
      allLoaded.value = false; // ✅ reset for new tab
    }

    isLoading.value = true;

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      final uri = Uri.parse(
        "${ApiEndPoint.order}?status=$selectedStatus&page=$page&limit=$limit",
      );

      debugPrint("Fetching orders: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data']['data'];

        if (list.isEmpty) {
          // ✅ No orders on this page, mark allLoaded
          allLoaded.value = true;
        }

        for (var e in list) {
          e['status'] = selectedStatus;

          final List stops = e['orderStops'] ?? [];

          final pickup = stops.firstWhere(
            (s) => s['type'] == 'PICKUP',
            orElse: () => {},
          );

          final drops = stops.where((s) => s['type'] == 'DROP').toList();

          e['pickup_address'] = pickup['address'] ?? "Collect from";
          e['sender_name'] = senderName;
          e['drop_off_address'] = drops.isNotEmpty
              ? drops.first['address']
              : "Deliver to";

          e['delivery_location'] = drops.length > 1
              ? drops.last['address']
              : "";

          orderList.add(OrderModel.fromJson(e));
        }

        debugPrint("Orders loaded: ${orderList.length}");
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

  /// Pull-to-refresh
  Future<void> refreshOrders() async {
    await fetchOrders(isRefresh: true);
  }

  /// Load more for pagination
  Future<void> loadMoreOrders() async {
    if (!allLoaded.value && !isLoading.value) {
      await fetchOrders();
    }
  }

  /// ✅ Call this when switching tabs
  void onTabChanged(int index) {
    if (selectOrderListIndex.value != index) {
      selectOrderListIndex.value = index;
      allLoaded.value = false; // reset loaded
      fetchOrders(isRefresh: true); // fetch for new tab
    }
  }
}
