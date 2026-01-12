import 'dart:convert';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/express_delivery_1/order_express_delivery/screen/order_alertdialog_screen.dart';
import 'package:ZipBee/features/user/express_delivery_1/service/order_api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// ─────────────────────────
/// Vehicle Model
/// ─────────────────────────
class VehicleModel {
  final String iconPath;
  VehicleModel(this.iconPath);
}

class ExpressDeliveryMain extends GetxController {
  // ─────────────────────────
  // Map Vehicle to ID
  // ─────────────────────────
  int _mapVehicleToId(VehicleModel? vehicle) {
    if (vehicle == null) return 1;

    switch (vehicle.iconPath) {
      case "assets/icons/bike.png":
        return 1;
      case "assets/icons/car.png":
        return 2;
      case "assets/icons/shop_car.png":
        return 3;
      case "assets/icons/shipment.png":
        return 4;
      default:
        return 1;
    }
  }

  // ─────────────────────────
  // Trip & Time State
  // ─────────────────────────
  final RxBool isRoundTrip = false.obs;
  final RxBool isNowSelected = true.obs;
  final Rxn<DateTime> scheduledDateTime = Rxn<DateTime>();

  // ─────────────────────────
  // UI Editing State
  // ─────────────────────────
  final RxBool isEditing = false.obs;
  final RxString title = 'Collected from (Sender: Athena Lin)'.obs;

  // ─────────────────────────
  // Sender & Receiver Info
  // ─────────────────────────
  final RxString senderName = ''.obs;
  final RxString senderAddress = ''.obs;
  final RxString receiverName = ''.obs;
  final RxString receiverAddress = ''.obs;

  // ─────────────────────────
  // Vehicle State
  // ─────────────────────────
  final RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  final Rxn<VehicleModel> selectedVehicle = Rxn<VehicleModel>();

  // ─────────────────────────
  // Additional State
  // ─────────────────────────
  final RxString orderNumber = '#1233'.obs;
  final RxBool isDriverAssigned = false.obs;
  final RxInt countdown = 10.obs;
  final RxBool redeemCoins = false.obs;
  final RxBool favoriteRiders = false.obs;
  final Rx<double> totalAmount = 0.0.obs;
  final RxBool isLoading = false.obs;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 90,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    loadVehicleData();
  }

  // ─────────────────────────
  // Vehicle Logic
  // ─────────────────────────
  void loadVehicleData() {
    vehicleList.assignAll([
      VehicleModel(IconPath.bike2),
      VehicleModel(IconPath.car2),
      VehicleModel(IconPath.shopcar),
      VehicleModel(IconPath.shipment),
    ]);
  }

  void selectVehicle(VehicleModel vehicle) {
    selectedVehicle.value = vehicle;
  }

  // ─────────────────────────
  // Trip Type
  // ─────────────────────────
  void toggleTripType(bool isRound) {
    isRoundTrip.value = isRound;
  }

  // ─────────────────────────
  // Schedule / Now Logic
  // ─────────────────────────
  void selectNow() {
    isNowSelected.value = true;
    scheduledDateTime.value = null;
  }

  void selectSchedule([DateTime? time]) {
    isNowSelected.value = false;
    if (time != null) {
      scheduledDateTime.value = time;
    }
  }

  String get formattedScheduledDateTime {
    if (scheduledDateTime.value == null) {
      return 'Pick Date and Time';
    }
    return DateFormat('EEE, dd MMM, hh:mm a').format(scheduledDateTime.value!);
  }

  // ─────────────────────────
  // Sender / Receiver Setter
  // ─────────────────────────
  void setSender({required String name, required String address}) {
    senderName.value = name;
    senderAddress.value = address;
  }

  void setReceiver({required String name, required String address}) {
    receiverName.value = name;
    receiverAddress.value = address;
  }

  // ─────────────────────────
  // Optional Title Update
  // ─────────────────────────
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }

  // ─────────────────────────
  // Toggle Methods
  // ─────────────────────────
  void toggleRedeemCoins(bool value) => redeemCoins.value = value;
  void toggleFavoriteRiders(bool value) => favoriteRiders.value = value;

  // ─────────────────────────
  // Create Order
  // ─────────────────────────
  Future<void> createOrder() async {
    if (totalAmount.value <= 0) {
      _logger.w("Order blocked: totalAmount is 0");
      return;
    }

    isLoading.value = true; // loader ON

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        _logger.e("Access token missing or expired");
        isLoading.value = false;
        Get.snackbar("Session Expired", "Please login again");
        return;
      }

      final body = {
        "route_type": isRoundTrip.value ? "ROUND" : "ONE_WAY",
        "delivery_type": "EXPRESS",
        "collect_time": isNowSelected.value ? "ASAP" : "SCHEDULED",
        "vehicle_type_id": _mapVehicleToId(selectedVehicle.value),
        "destinations": [
          {"type": "SENDER", "address": senderAddress.value},
          {"type": "RECEIVER", "address": receiverAddress.value},
        ],
        if (!isNowSelected.value && scheduledDateTime.value != null)
          "scheduled_time": scheduledDateTime.value!.toIso8601String(),
      };

      _logger.i("Create Order → Request Body");
      _logger.d(body);

      final response = await OrderService.createOrderApi(
        body: body,
        token: token,
      );

      _logger.i("Status Code → ${response.statusCode}");
      _logger.d("Response → ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i("Order Created Successfully");

        final orderData = data['data']?['order'];
        if (orderData != null && orderData is Map<String, dynamic>) {
          // Pass the order id to the confirmation dialog so it can display the order number
          OrderConfirmationSheet.show(orderData['id']);
        } else {
          _logger.w("Order data missing or invalid in response");
          Get.snackbar("Success", "Order created but no details available");
        }
      } else {
        final errorMessage = data['message'] is List
            ? (data['message'] as List).join('\n')
            : data['message']?.toString() ?? "Order Failed";

        _logger.e("Order Failed", error: data);
        Get.snackbar("Error", errorMessage);
      }
    } catch (e, s) {
      _logger.f("Create Order Exception", error: e, stackTrace: s);
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false; // loader OFF
    }
  }
}
