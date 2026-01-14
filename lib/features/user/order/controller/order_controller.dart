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

  int page = 1;
  final int limit = 20;
  String senderName = "Collect from";

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

  final RxBool allLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchOrders(isRefresh: true);
  }

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
      }
    } catch (e) {
      debugPrint("Profile error: $e");
    }
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (isRefresh) {
      page = 1;
      orderList.clear();
      allLoaded.value = false;
    }
    isLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;
      final uri = Uri.parse(
        "${ApiEndPoint.order}?status=$selectedStatus&page=$page&limit=$limit",
      );
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token", "accept": "*/*"},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data']['data'];
        if (list.isEmpty) allLoaded.value = true;
        for (var e in list) {
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
        page++;
      }
    } catch (e) {
      debugPrint("Orders error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRiderInfoById(int riderId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = ApiEndPoint.updateProfile.replaceAll(
        "{id}",
        riderId.toString(),
      );
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];

        // Update orderList items with fetched rider info
        for (int i = 0; i < orderList.length; i++) {
          if (orderList[i].riderId == riderId) {
            orderList[i] = orderList[i].copyWith(
              assignRiderName: data['username'],
              assignRiderPhone: data['phone'],
              assignRiderImage: data['image'] ?? "",
              assignRiderRating:
                  double.tryParse(
                    data['avg_raiderRating']?.toString() ?? '0',
                  ) ??
                  0.0,
              assignRiderReviews: data['total_raiderRatings'] ?? 0,
            );
          }
        }
        orderList.refresh();
      }
    } catch (e) {
      debugPrint("fetchRiderInfoById error: $e");
    }
  }

  Future<void> refreshOrders() async => await fetchOrders(isRefresh: true);
  Future<void> loadMoreOrders() async {
    if (!allLoaded.value && !isLoading.value) await fetchOrders();
  }

  void onTabChanged(int index) {
    if (selectOrderListIndex.value != index) {
      selectOrderListIndex.value = index;
      allLoaded.value = false;
      fetchOrders(isRefresh: true);
    }
  }
}
