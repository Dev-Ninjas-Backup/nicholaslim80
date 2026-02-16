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
  final RxBool isDetailLoading = false.obs;

  final orderTabs = ["Active", "Completed", "Cancelled"];
  final RxList<OrderModel> orderList = <OrderModel>[].obs;
  final Rxn<OrderModel> singleOrder = Rxn<OrderModel>();

  get totalAmount => null;
  get favoriteRiders => null;
  get orderNumber => null;

  final RxBool redeemCoins = false.obs;
  void toggleRedeemCoins(bool? value) => redeemCoins.value = value ?? false;

  final RxBool toggleFavoriteRiders = false.obs;

  int page = 1;
  final int limit = 20;
  String senderName = "";

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
        final data = decoded['data'];
        senderName = data['username'] ?? "";

        if (data['raiderProfile'] != null &&
            data['raiderProfile']['registrations'] != null &&
            (data['raiderProfile']['registrations'] as List).isNotEmpty) {
          final reg = data['raiderProfile']['registrations'][0];
          senderName = reg['raider_name'] ?? senderName;
        }
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

          e['pickup_address'] = pickup['address'] ?? "";
          e['pickup_lat'] = pickup['latitude'];
          e['pickup_long'] = pickup['longitude'];
          e['sender_name'] = senderName;

          if (drops.isNotEmpty) {
            e['drop_off_address'] = drops.first['address'] ?? "";
            e['drop_off_lat'] = drops.first['latitude'];
            e['drop_off_long'] = drops.first['longitude'];
          }
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

  Future<void> fetchOrderDetail(String orderIdParam) async {
    isDetailLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = ApiEndPoint.getOrder.replaceAll("{orderId}", orderIdParam);

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];

        /// ✅ ADD THIS (Order ID)
        final int orderId = data['id'] is int
            ? data['id']
            : int.tryParse(data['id'].toString()) ?? 0;

        debugPrint("Order ID: $orderId");

        final List stops = data['orderStops'] ?? [];

        final pickup = stops.firstWhere(
          (s) => s['type'] == 'PICKUP',
          orElse: () => {},
        );
        final drops = stops.where((s) => s['type'] == 'DROP').toList();

        data['pickup_address'] = pickup['address'] ?? "";
        data['pickup_lat'] = pickup['latitude'];
        data['pickup_long'] = pickup['longitude'];
        data['sender_name'] = data['user']?['username'] ?? senderName;

        if (drops.isNotEmpty) {
          data['drop_off_address'] = drops.first['address'] ?? "";
          data['drop_off_lat'] = drops.first['latitude'];
          data['drop_off_long'] = drops.first['longitude'];
          data['recipient_name'] =
              drops.first['destination']?['contact_name'] ?? "";
        }

        singleOrder.value = OrderModel.fromJson(data);

        /// ✅ If you want to use extracted orderId
        // await someFunction(orderId);

        if (data['assign_rider']?['userId'] != null) {
          await fetchRiderInfoByIdForSingle(data['assign_rider']['userId']);
        } else if (singleOrder.value?.riderId != null) {
          await fetchRiderInfoByIdForSingle(singleOrder.value!.riderId!);
        }
      }
    } catch (e) {
      debugPrint("fetchOrderDetail error: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }

  // ✅ Corrected method to handle multiple pickup stops
  List<Map<String, String>> getPickupStops(OrderModel? order) {
    if (order == null || order.rawOrderStops == null) return [];

    final List stops = order.rawOrderStops!;
    final filtered = stops.where((s) => s['type'] == 'PICKUP').toList();

    if (filtered.isEmpty) {
      return [
        {"name": order.senderName, "address": order.pickupAddress},
      ];
    }

    return filtered
        .map<Map<String, String>>(
          (s) => {
            "name":
                s['destination']?['contact_name']?.toString() ??
                order.senderName,
            "address": s['address']?.toString() ?? order.pickupAddress,
          },
        )
        .toList();
  }

  // ✅ Corrected method to handle multiple drop stops
  List<Map<String, String>> getDropStops(OrderModel? order) {
    if (order == null || order.rawOrderStops == null) return [];

    final List stops = order.rawOrderStops!;
    final filtered = stops.where((s) => s['type'] == 'DROP').toList();

    if (filtered.isEmpty) {
      return [
        {"name": order.recipientName, "address": order.dropOffAddress},
      ];
    }

    return filtered
        .map<Map<String, String>>(
          (s) => {
            "name":
                s['destination']?['contact_name']?.toString() ??
                order.recipientName,
            "address": s['address']?.toString() ?? order.dropOffAddress,
          },
        )
        .toList();
  }

  Future<void> fetchRiderInfoByIdForSingle(int riderUserId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = ApiEndPoint.updateProfile.replaceAll(
        "{id}",
        riderUserId.toString(),
      );
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        String riderName = "";
        String riderImage = data['image'] ?? "";

        if (data['raiderProfile']?['registrations'] != null &&
            (data['raiderProfile']['registrations'] as List).isNotEmpty) {
          final reg = data['raiderProfile']['registrations'][0];
          riderName = reg['raider_name'] ?? "";
        }

        if (singleOrder.value != null) {
          singleOrder.value = singleOrder.value!.copyWith(
            assignRiderName: singleOrder.value!.assignRiderName.isNotEmpty
                ? singleOrder.value!.assignRiderName
                : riderName,
            assignRiderPhone: data['phone'],
            assignRiderImage: riderImage,
            assignRiderRating:
                double.tryParse(data['avg_raiderRating']?.toString() ?? '0') ??
                0.0,
            assignRiderReviews: data['total_raiderRatings'] ?? 0,
          );
        }
      }
    } catch (e) {
      debugPrint("fetchRiderInfoByIdForSingle error: $e");
    }
  }

  Future<void> fetchRiderInfoById(int riderUserId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final url = ApiEndPoint.updateProfile.replaceAll(
        "{id}",
        riderUserId.toString(),
      );
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        String riderName = "";
        String riderImage = data['image'] ?? "";

        if (data['raiderProfile']?['registrations'] != null &&
            (data['raiderProfile']['registrations'] as List).isNotEmpty) {
          final reg = data['raiderProfile']['registrations'][0];
          riderName = reg['raider_name'] ?? "";
        }

        for (int i = 0; i < orderList.length; i++) {
          if (orderList[i].riderId == riderUserId) {
            orderList[i] = orderList[i].copyWith(
              assignRiderName: orderList[i].assignRiderName.isNotEmpty
                  ? orderList[i].assignRiderName
                  : riderName,
              assignRiderPhone: data['phone'],
              assignRiderImage: riderImage,
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

  // OrderController এর ভেতরে এই মেথডটি আপডেট বা যোগ করুন
  Future<void> fetchRiderRatings(int riderId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final uri = Uri.parse('${ApiEndPoint.rating}?type=raider&id=$riderId');

      final res = await http.get(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final Map<String, dynamic> dataMap = body['data'] ?? {};
        final List list = dataMap['data'] ?? [];

        double totalStar = 0;
        for (var item in list) {
          totalStar += (item['rating_star'] ?? 0).toDouble();
        }

        // অরিজিনাল এভারেজ এবং রিভিউ কাউন্ট আপডেট করা
        if (singleOrder.value != null) {
          singleOrder.value = singleOrder.value!.copyWith(
            assignRiderRating: list.isNotEmpty
                ? (totalStar / list.length)
                : 0.0,
            assignRiderReviews: list.length,
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching rider ratings: $e");
    }
  }

  Future<void> refreshOrders() async => fetchOrders(isRefresh: true);
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
