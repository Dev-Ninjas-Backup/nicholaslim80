import 'package:ZipBee/features/user/finding_raider/services/priority_order_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/model/payment_option_model.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/connecting_rider_page.dart';
import 'package:ZipBee/features/user/finding_raider/services/place_order_service.dart';
import 'package:ZipBee/features/user/finding_raider/services/get_order_api_service.dart';

class OrderStopMapPoint {
  final String stopType;
  final String address;
  final String name;
  final double latitude;
  final double longitude;
  final int sequence;

  const OrderStopMapPoint({
    required this.stopType,
    required this.address,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sequence,
  });
}

class RiderController extends GetxController {
  final _box = GetStorage(); // GetStorage instance
  RxInt orderId = 0.obs;

  RxInt selectedFare = 0.obs;

  RxString riderName = 'Dylan Simpson'.obs;
  RxString vehicleType = 'Truck'.obs;
  RxString arrivalTime = '10 min'.obs;
  RxString dateTime = '25 September 2025 / 9:40 am'.obs;

  RxBool firstActive = true.obs;
  RxBool secondActive = false.obs;

  RxDouble pickupLat = 0.0.obs;
  RxDouble pickupLng = 0.0.obs;

  RxString pickupName = ''.obs;
  RxString pickupAddress = ''.obs;
  RxString dropName = ''.obs;
  RxString dropAddress = ''.obs;

  // --- New Lists for Multiple Stops ---
  RxList<Map<String, String>> pickupStops = <Map<String, String>>[].obs;
  RxList<Map<String, String>> dropStops = <Map<String, String>>[].obs;
  RxList<OrderStopMapPoint> routeStops = <OrderStopMapPoint>[].obs;

  // New loading state for API
  RxBool isLoading = false.obs;

  // Order Payment Information
  RxDouble totalCost = 0.0.obs;
  RxString paymentType = ''.obs; // COD, WALLET, ONLINE_PAY
  RxString routeType = 'ONE_WAY'.obs;
  RxBool assignRiderNull = true.obs;
  Rx<dynamic> assignRiderData = Rx<dynamic>(null);
  RxString orderCreatedAt = ''.obs;
  RxString scheduledTime = ''.obs;
  RxString orderUpdatedAt = ''.obs;
  RxString riderFormattedAverage = '0'.obs;

  Timer? _pollTimer;

  // fareOptions এখন রিয়েল-টাইম আপডেট হবে এবং ক্যাশ থেকে ডাটা নিবে
  final RxList<double> fareOptions = <double>[5, 10, 15, 20].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFareOptionsFromCache(); // কন্ট্রোলার স্টার্ট হওয়ার সময় ক্যাশ লোড হবে
  }

  // ক্যাশ থেকে ইউনিক ৪টি অ্যামাউন্ট লোড করার মেথড
  void _loadFareOptionsFromCache() {
    List? savedFares = _box.read<List>('fare_cache');
    if (savedFares != null && savedFares.isNotEmpty) {
      fareOptions.assignAll(savedFares.cast<double>());
      debugPrint('✅ Cache Loaded: $savedFares');
    }
  }

  // নতুন অ্যামাউন্ট অ্যাড এবং ক্যাশ সেভ করার মেথড (ইউনিক ৪টি)
  void addNewAmount(double amount) {
    debugPrint('🚀 Adding new amount to cache: $amount');

    List<double> currentList = List<double>.from(fareOptions);

    // যদি অ্যামাউন্টটি আগে থেকেই থাকে, তবে সেটি রিমুভ করে শুরুতে নিয়ে আসবো (ইউনিক রাখতে)
    currentList.remove(amount);
    currentList.insert(0, amount);

    // ৪টির বেশি ডাটা রাখবো না
    if (currentList.length > 4) {
      currentList = currentList.sublist(0, 4);
    }

    fareOptions.assignAll(currentList);
    _box.write('fare_cache', currentList); // ক্যাশে পার্মানেন্টলি সেভ
    selectedFare.value = 0; // নতুন অ্যামাউন্টটি সিলেক্টেড থাকবে
    debugPrint('✅ Storage Updated: $currentList');
  }

  // --- নতুন ডাটা ফেচিং মেথড ---
  Future<void> fetchOrderData(int id, {bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
    }
    debugPrint('🚀 fetchOrderData started for ID: $id');

    try {
      final result = await GetOrderApiService.fetchOrderDetails(id);

      debugPrint(
        '📊 API Response: Success=${result['success']}, HasData=${result['data'] != null}',
      );

      if (result['success'] == true && result['data'] != null) {
        final data = result['data'];
        final pricingSummary = data['pricingSummary'] as Map<String, dynamic>?;

        // =========================
        // Payment Information
        // =========================
        totalCost.value =
            double.tryParse(
              pricingSummary?['totalCost']?.toString() ??
                  data['total_cost']?.toString() ??
                  '0',
            ) ??
            0.0;
        paymentType.value = data['pay_type'] ?? '';
        routeType.value = (data['route_type'] ?? 'ONE_WAY').toString();
        orderCreatedAt.value = data['created_at'] ?? '';
        scheduledTime.value = data['scheduled_time'] ?? '';
        orderUpdatedAt.value = data['updated_at'] ?? '';
        riderFormattedAverage.value = (data['formattedAverage'] ?? '0')
            .toString();

        // =========================
        // Assign Rider Info
        // =========================
        assignRiderData.value = data['assign_rider'];
        assignRiderNull.value = data['assign_rider'] == null;

        // ✅ এই জায়গা থেকে আমরা assign_rider এর id এবং userId fetch করছি
        final assignRider = data['assign_rider'];

        if (assignRider != null) {
          // 🚴 Assign Rider ID
          final riderId = assignRider['id'];

          // 👤 Assign Rider UserID
          final riderUserId = assignRider['userId'];

          debugPrint('🚴 Assign Rider ID: $riderId'); // <-- এখানে
          debugPrint('👤 Assign Rider UserID: $riderUserId'); // <-- এখানে
        } else {
          debugPrint('❌ No Assign Rider Found');
        }

        // =========================
        // Save orderId to controller
        // =========================
        orderId.value = id;

        debugPrint('✅ Order Fetched Successfully:');
        debugPrint('   - Order ID: $id');
        debugPrint('   - Total Cost: ${totalCost.value}');
        debugPrint('   - Payment Type: ${paymentType.value}');
        debugPrint('   - Route Type: ${routeType.value}');
        debugPrint('   - Created At: ${orderCreatedAt.value}');

        // =========================
        // Order Stops
        // =========================
        final List orderStops = data['orderStops'] ?? [];

        pickupStops.clear();
        dropStops.clear();
        routeStops.clear();

        for (var stop in orderStops) {
          final destination = stop['destination'];

          if (destination != null && stop is Map<String, dynamic>) {
            final String stopType = (stop['type'] ?? '').toString();
            final lat =
                (stop['latitude'] as num?)?.toDouble() ??
                (destination['latitude'] as num?)?.toDouble();
            final lng =
                (stop['longitude'] as num?)?.toDouble() ??
                (destination['longitude'] as num?)?.toDouble();
            final sequence = (stop['sequence'] as num?)?.toInt() ?? 0;

            if (lat != null && lng != null) {
              routeStops.add(
                OrderStopMapPoint(
                  stopType: stopType,
                  address:
                      (destination['addressFromApr'] ??
                              destination['address'] ??
                              '')
                          .toString(),
                  name: (destination['contact_name'] ?? '').toString(),
                  latitude: lat,
                  longitude: lng,
                  sequence: sequence,
                ),
              );
            }

            final String destinationType = (destination['type'] ?? '')
                .toString();

            if (destinationType == 'SENDER') {
              pickupStops.add({
                'name': destination['contact_name'] ?? '',
                'address': destination['address'] ?? '',
              });

              pickupName.value = destination['contact_name'] ?? '';
              pickupAddress.value = destination['address'] ?? '';

              debugPrint('✅ Pickup Set: ${pickupName.value}');
            } else if (destinationType == 'RECEIVER') {
              dropStops.add({
                'name': destination['contact_name'] ?? '',
                'address': destination['address'] ?? '',
              });

              dropName.value = destination['contact_name'] ?? '';
              dropAddress.value = destination['address'] ?? '';

              debugPrint('✅ Drop Set: ${dropName.value}');
            }
          }
        }

        routeStops.sort((a, b) => a.sequence.compareTo(b.sequence));

        debugPrint(
          '📦 Total Pickups: ${pickupStops.length}, Total Drops: ${dropStops.length}',
        );
      } else {
        debugPrint('❌ API Success was false or data was null');
        debugPrint('❌ Response: $result');
      }
    } catch (e) {
      debugPrint('❌ Controller Error: $e');
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  // Poll order to check assign_rider status
  Future<void> startPollingAssignRider(VoidCallback? onAssignedRider) async {
    // Get order ID from StackedOrderController
    final StackedOrderController orderController =
        Get.find<StackedOrderController>();
    String rawId = orderController.orderNumber.value.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    int? id = int.tryParse(rawId);

    if (id == null || id == 0) {
      debugPrint('❌ Invalid Order ID');
      return;
    }

    _pollTimer?.cancel();

    // Initial fetch
    await fetchOrderData(id);

    if (!assignRiderNull.value) {
      onAssignedRider?.call();
      return;
    }

    _pollTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      debugPrint('🔄 Polling order $id...');
      await fetchOrderData(id, showLoader: false);

      if (!assignRiderNull.value) {
        debugPrint('✅ Rider assigned! Stopping poll.');
        timer.cancel();
        onAssignedRider?.call();
      }
    });
  }

  void stopPollingAssignRider() {
    _pollTimer?.cancel();
    _pollTimer = null;
    debugPrint('⏹️ Polling stopped');
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  void setPickupLocation(double lat, double lng) {
    pickupLat.value = lat;
    pickupLng.value = lng;
    print('📍 Pickup set: $lat, $lng');
  }

  void setLocationFromApi({
    required String pickupName,
    required String pickupAddress,
    required String dropName,
    required String dropAddress,
  }) {
    this.pickupName.value = pickupName;
    this.pickupAddress.value = pickupAddress;
    this.dropName.value = dropName;
    this.dropAddress.value = dropAddress;
  }

  RxInt rating = 0.obs;
  void setRating(int value) => rating.value = value;

  RxInt selectedMethod = 0.obs;

  final paymentOptions = <PaymentOptionModel>[
    PaymentOptionModel(
      title: 'Stripe',
      subtitle: 'Temporarily unavailable',
      assetPath: IconPath.stripe,
    ),
    PaymentOptionModel(
      title: 'Wallet (with balance)',
      subtitle: 'S\$10.50',
      assetPath: IconPath.wallet,
    ),
    PaymentOptionModel(
      title: 'Cash',
      subtitle: 'To be paid by sender or recipient',
      assetPath: IconPath.cash,
    ),
  ];

  void selectMethod(int index) => selectedMethod.value = index;

  // fareOptions এখন RxList থেকে ডাইনামিকলি কাজ করবে
  void selectFare(int index) => selectedFare.value = index;

  RxInt selectedRaiderTip = 0.obs;
  final List<double> raiderTipOptions = [10, 20, 40, 100];
  void selectTip(int index) => selectedRaiderTip.value = index;

  RxBool isPlacingOrder = false.obs;
  RxBool isCancelling = false.obs;

  Future<void> placeOrder() async {
    if (isPlacingOrder.value) return;

    isPlacingOrder.value = true;

    try {
      final success = await PlaceOrderService.placeOrder(
        orderId: orderId.value,
        paymentMethod: _paymentMethod(),
        paymentMethodId: _paymentMethodId(),
      );

      if (success) {
        firstActive.value = false;
        secondActive.value = true;

        Get.to(() => ConnectingRiderPage());
      } else {
        Get.snackbar('Order Failed', 'Please try again');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isPlacingOrder.value = false;
    }
  }

  Future<void> cancelOrder({required String reason}) async {
    if (isCancelling.value) return;

    isCancelling.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      Get.snackbar('Order Cancelled', reason);
    } finally {
      isCancelling.value = false;
    }
  }

  Future<void> priorityOrder() async {
    if (isLoading.value) return;

    // ১. বর্তমানে সিলেক্টেড অ্যামাউন্ট গেট করা
    double selectedAmount = fareOptions[selectedFare.value];

    // ২. অর্ডার আইডি গেট করা (আপনার স্ট্যাকড অর্ডার কন্ট্রোলার থেকে)
    final StackedOrderController orderController =
        Get.find<StackedOrderController>();
    String rawId = orderController.orderNumber.value.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    int? id = int.tryParse(rawId);

    if (id == null || id == 0) {
      EasyLoading.showError("Invalid Order ID");
      return;
    }

    EasyLoading.show(status: 'Processing Priority...');

    try {
      final res = await PriorityOrderService.makePriorityOrder(
        orderId: id,
        amount: selectedAmount,
      );

      if (res['success'] == true) {
        EasyLoading.showSuccess('Priority Order Activated!');

        // Success হলে পরবর্তী স্ক্রিনে যাওয়া
        firstActive.value = false;
        secondActive.value = true;
        Get.to(() => ConnectingRiderPage());
      } else {
        String msg = res['body']['message'] ?? "Failed to prioritize order";
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
      debugPrint("❌ Priority Order UI Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  String _paymentMethod() {
    switch (selectedMethod.value) {
      case 1:
        return 'WALLET';
      case 2:
        return 'COD';
      default:
        return 'COD';
    }
  }

  String _paymentMethodId() {
    if (selectedMethod.value == 1) {
      return 'wallet_balance';
    }
    return '';
  }
}
