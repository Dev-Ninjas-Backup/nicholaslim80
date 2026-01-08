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
    debugPrint("OrderController initialized. Fetching orders...");
    fetchOrders(isRefresh: true);
  }

  /// Fetch all destinations for current user
  Future<List<Map<String, dynamic>>> fetchAllDestinations() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      debugPrint("Access token for destinations: $token");

      if (token == null || token.isEmpty) return [];

      final uri = Uri.parse(ApiEndPoint.getDestination);
      debugPrint("Fetching all destinations: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      debugPrint("Destinations response status: ${response.statusCode}");
      debugPrint("Destinations response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          debugPrint("Total destinations fetched: ${decoded['data'].length}");
          return List<Map<String, dynamic>>.from(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching destinations: $e");
    }
    return [];
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) {
      debugPrint("Already loading orders. Skipping fetch.");
      return;
    }

    if (isRefresh) {
      page = 1;
      orderList.clear();
      debugPrint("Refreshing orders. Page reset to 1, order list cleared.");
    }

    isLoading.value = true;
    debugPrint(
      "Fetching orders... Status: $selectedStatus, Page: $page, Limit: $limit",
    );

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      debugPrint("Access token for order API: $token");
      if (token == null || token.isEmpty) return;

      // --- Fetch all destinations once ---
      final allDestinations = await fetchAllDestinations();

      final uri = Uri.parse(
        "${ApiEndPoint.order}?status=$selectedStatus&page=$page&limit=$limit",
      );
      debugPrint("Order API URL: $uri");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );

      debugPrint("Order response status: ${response.statusCode}");
      debugPrint("Order response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data']['data'];
        debugPrint("Number of orders fetched: ${list.length}");

        for (var e in list) {
          e['status'] = selectedStatus;
          debugPrint("Processing order ID: ${e['id']}");

          // --- Map pickup and dropoff using allDestinations ---
          Map<String, dynamic>? pickupData = allDestinations.firstWhere(
            (d) =>
                d['id'] == e['pickup_destination_id'] && d['type'] == 'SENDER',
            orElse: () => {},
          );
          Map<String, dynamic>? dropoffData = allDestinations.firstWhere(
            (d) =>
                d['id'] == e['dropoff_destination_id'] &&
                d['type'] == 'RECEIVER',
            orElse: () => {},
          );

          e['sender_name'] = pickupData['contact_name'] ?? "Unknown";
          e['pickup_address'] = pickupData['addressFromApr'] ?? "Collect from";
          e['delivery_location'] =
              dropoffData['addressFromApr'] ?? "Delivery Location";
          e['drop_off_address'] =
              e['drop_off_address'] ??
              "Deliver to ${e['total_stops'] ?? 1} destination(s)";

          final order = OrderModel.fromJson(e);
          debugPrint(
            "Mapped order: ${order.orderId}, Sender: ${order.senderName}, Delivery: ${order.deliveryLocation}",
          );

          orderList.add(order);
        }

        page++;
        debugPrint("Orders loaded. Next page: $page");
      } else {
        debugPrint(
          "Failed to load orders. Status code: ${response.statusCode}",
        );
        Get.snackbar("Error", "Failed to load orders");
      }
    } catch (e) {
      debugPrint("Error in fetchOrders: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      debugPrint("Order loading finished.");
    }
  }
}
