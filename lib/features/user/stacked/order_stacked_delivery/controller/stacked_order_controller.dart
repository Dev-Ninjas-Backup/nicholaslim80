import 'package:ZipBee/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/cancel_order_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/notify_rider.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/promo_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/widget/pic_date_time.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/order_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/payment_method_widget.dart';

class StackedOrderController extends GetxController {
  var orderNumber = '#1233'.obs;
  var isDriverAssigned = false.obs;
  var countdown = 10.obs;

  // New properties for Order Confirmation Details
  var totalAmount = 0.0.obs; // Will be set before showing dialog (server value)
  var totalFee = 0.0.obs; // server-side fee (preferred display when available)
  var redeemCoins = false.obs;
  var favoriteRiders = false.obs;
  int userCoinBalance = 0; // User's current coin balance from API

  // Route options
  var isFixed = false.obs; // Fixed route toggle

  // API Response Data
  var placeOrderResponse = Rx<Map<String, dynamic>?>(null);
  var isAutoConfirmation = false.obs;
  var collectTime = 'ASAP'.obs; // 'ASAP' or 'SCHEDULED'
  var senderInfo = Rx<Map<String, dynamic>?>(null);
  var receiverInfo = Rx<Map<String, dynamic>?>(null);

  var isCancelling = false.obs;

  Future<void> handleOrderCancellation(String? reason) async {
    if (lastOrderId == null) {
      cancelAndReset();
      Get.offAll(() => BottomNavbarScreen());
      return;
    }

    try {
      isCancelling.value = true;

      final result = await CancelOrderService.cancelOrder(lastOrderId!, reason);

      isCancelling.value = false;

      if (result['success'] == true) {
        EasyLoading.showSuccess('Order Cancelled');

        cancelAndReset();

        Get.offAll(() => BottomNavbarScreen());
      } else {
        String errorMsg =
            result['body']?['message'] ?? 'Failed to cancel order';
        EasyLoading.showError(errorMsg);
      }
    } catch (e) {
      isCancelling.value = false;
      debugPrint('Error in handleOrderCancellation: $e');
      EasyLoading.showError('An error occurred while cancelling');
    }
  }

  void toggleRedeemCoins(bool value) {
    redeemCoins.value = value;
  }

  Future<void> toggleFavoriteRiders(bool value) async {
    // UI instantly update
    favoriteRiders.value = value;

    // If order is ASAP → backend does not support notify API
    if (collectTime.value == 'ASAP') {
      debugPrint('⚠️ Favourite rider API skipped (ASAP order)');
      return;
    }

    if (lastOrderId == null) {
      EasyLoading.showError('Order not found');
      return;
    }

    EasyLoading.show(status: 'Updating...');

    final res = await NotifyRider.notifyRider(
      orderId: lastOrderId.toString(),
      notifyRider: value,
    );

    EasyLoading.dismiss();

    final success = res['success'] ?? false;

    if (success) {
      final body = res['body'] as Map<String, dynamic>? ?? {};
      final data = body['data'] as Map<String, dynamic>? ?? {};

      favoriteRiders.value = data['notify_favorite_raider'] ?? value;

      EasyLoading.showSuccess(body['message'] ?? 'Updated successfully');
    } else {
      // revert toggle
      favoriteRiders.value = !value;
      EasyLoading.showError('Failed to update favourite rider');
    }
  }

  /// Place order by building payload from controllers, call POST endpoint,
  /// then GET the created order, debugPrint responses, update `totalAmount`
  /// and return true on success. Returns false on validation or server error.
  int? lastOrderId;

  Future<bool> placeOrder({
    required StackedLocationController locationController,
    required StackedVehicleController vehicleController,
  }) async {
    // Validate required fields
    final vehicle = vehicleController.selectedVehicle.value;
    final sender = locationController.senderData.value;
    final receiver = locationController.receiverData.value;

    if (vehicle == null) {
      EasyLoading.showError('Please select a vehicle');
      return false;
    }

    if (sender == null) {
      EasyLoading.showError('Please select a pickup address');
      return false;
    }

    if (receiver == null) {
      EasyLoading.showError('Please select at least one recipient address');
      return false;
    }

    // Build destinations array - currently supports sender + one receiver
    final destinations = <Map<String, dynamic>>[];

    destinations.add({
      'address': sender.address,
      'floor_unit': sender.floorUnit,
      'contact_name': sender.contactName,
      'contact_number': sender.contactNumber,
      'note_to_driver': sender.noteToDriver,
      'is_saved': sender.isSaved,
      'type': 'SENDER',
    });

    // Add primary receiver - if you support more stops later, append here
    destinations.add({
      'address': receiver.address,
      'floor_unit': receiver.floorUnit,
      'contact_name': receiver.contactName,
      'contact_number': receiver.contactNumber,
      'note_to_driver': receiver.noteToDriver,
      'is_saved': receiver.isSaved,
      'type': 'RECEIVER',
    });

    // Collect time
    String collectTime = 'ASAP';
    String? scheduledTime;
    StackedScheduleController? schedCtrl;
    try {
      schedCtrl = Get.find<StackedScheduleController>();
    } catch (_) {
      schedCtrl = null;
    }

    if (schedCtrl != null && !schedCtrl.isNow.value) {
      scheduledTime = schedCtrl.selectedDateTime.value
          .toUtc()
          .toIso8601String();
      collectTime = 'SCHEDULED';
    }

    final payload = {
      'route_type': locationController.isRoundTrip.value ? 'ROUND' : 'ONE_WAY',
      'isFixed': isFixed.value,
      'delivery_type': 'STACKED',
      'vehicle_type_id': vehicle.id,
      'collect_time': collectTime, // sends either 'ASAP' or 'SCHEDULED'
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
    };

    debugPrint('Placing order payload: $payload');

    final res = await OrderService.createOrder(payload);

    // Debug print full response
    debugPrint('CreateOrder full response: ${res}');

    final status = res['statusCode'] as int? ?? 500;
    if (status == 201) {
      EasyLoading.showSuccess('Order created');
      final body = res['body'] as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? {};

      // Extract total cost - try order.total_cost then pricingSummary.totalCost
      double serverTotal = 0.0;
      try {
        final orderMap = data['order'] as Map<String, dynamic>?;
        if (orderMap != null && orderMap['total_cost'] != null) {
          serverTotal =
              double.tryParse(orderMap['total_cost'].toString()) ?? 0.0;
        } else if (data['pricingSummary'] != null &&
            data['pricingSummary']['totalCost'] != null) {
          serverTotal = (data['pricingSummary']['totalCost'] as num).toDouble();
        }
      } catch (e) {
        debugPrint('Error parsing server total: $e');
      }

      debugPrint('Server total_cost: $serverTotal');

      // Parse server total_fee if present
      double serverFee = 0.0;
      try {
        final orderMap = data['order'] as Map<String, dynamic>?;
        if (orderMap != null && orderMap['total_fee'] != null) {
          serverFee = double.tryParse(orderMap['total_fee'].toString()) ?? 0.0;
        } else if (data['total_fee'] != null) {
          serverFee = double.tryParse(data['total_fee'].toString()) ?? 0.0;
        }
      } catch (e) {
        debugPrint('Error parsing server fee: $e');
      }

      debugPrint('Server total_fee: $serverFee');

      // If order id is present, fetch order details and store lastOrderId
      int? orderId;
      try {
        final orderMap = data['order'] as Map<String, dynamic>?;
        orderId = orderMap != null && orderMap['id'] != null
            ? (orderMap['id'] as int)
            : null;
      } catch (_) {
        orderId = null;
      }

      if (orderId != null) {
        // save for later 'place' call
        lastOrderId = orderId;
        final getRes = await OrderService.getOrder(orderId);
        debugPrint('Get order full response: $getRes');
      }

      // Update controller totals to server values and return success
      totalAmount.value = serverTotal;
      totalFee.value = serverFee;
      return true;
    } else {
      final msg =
          (res['body'] as Map<String, dynamic>?)?['message'] ??
          'Failed to create order';
      debugPrint('PlaceOrder failed: $msg');
      EasyLoading.showError(msg.toString());
      return false;
    }
  }

  /// After creating an order (lastOrderId must be present), finalize/place it.
  Future<bool> confirmPlaceOrder({
    required String paymentMethod, // COD | WALLET | ONLINE_PAY
    String? paymentMethodId,
    String? codCollectFrom, // SENDER | RECEIVER
  }) async {
    if (lastOrderId == null) {
      EasyLoading.showError('No order available to place');
      debugPrint('confirmPlaceOrder: lastOrderId is null');
      return false;
    }

    debugPrint(
      'Placing final order - Order ID: $lastOrderId, Payment Method: $paymentMethod, PaymentMethodId: $paymentMethodId, CodCollectFrom: $codCollectFrom',
    );

    final res = await OrderService.placeOrder(
      orderId: lastOrderId!,
      paymentMethod: paymentMethod,
      codCollectFrom: codCollectFrom,
      paymentMethodId: paymentMethodId,
    );

    debugPrint('Place order full response: $res');

    final status = res['statusCode'] as int? ?? 500;
    final bodyData = res['body'] as Map<String, dynamic>? ?? {};
    final success = bodyData['success'] as bool? ?? false;

    // Check both status code and success flag
    if (success && (status == 201 || status == 200)) {
      try {
        // Save full response for later use
        placeOrderResponse.value = bodyData;

        final data = bodyData['data'] as Map<String, dynamic>? ?? {};

        // Extract order ID and update orderNumber
        final orderId = data['id'] as int? ?? lastOrderId;
        orderNumber.value = '#${orderId.toString().padLeft(6, '0')}';

        // Extract is_auto_confirmation flag
        isAutoConfirmation.value =
            (data['is_auto_confirmation'] as bool?) ?? false;
        debugPrint('Is Auto Confirmation: ${isAutoConfirmation.value}');

        // Extract collect_time
        collectTime.value = (data['collect_time'] as String?) ?? 'ASAP';
        debugPrint('Collect Time: ${collectTime.value}');

        // Extract sender and receiver info from destinations
        final destinations = data['destinations'] as List<dynamic>? ?? [];
        for (var dest in destinations) {
          final destMap = dest as Map<String, dynamic>? ?? {};
          final type = destMap['type'] as String? ?? '';

          if (type == 'SENDER') {
            senderInfo.value = destMap;
            debugPrint('Sender Info: $destMap');
          } else if (type == 'RECEIVER') {
            receiverInfo.value = destMap;
            debugPrint('Receiver Info: $destMap');
          }
        }

        final serverTotal =
            double.tryParse((data['total_cost'] ?? '').toString()) ??
            totalAmount.value;
        double serverFee = 0.0;
        try {
          serverFee =
              double.tryParse((data['total_fee'] ?? '').toString()) ??
              serverFee;
        } catch (_) {}
        debugPrint(
          'Placed order total_cost: $serverTotal total_fee: $serverFee',
        );
        totalAmount.value = serverTotal;
        totalFee.value = serverFee;
        EasyLoading.showSuccess(
          'Order placed: S\$${serverTotal.toStringAsFixed(2)}',
        );
      } catch (e) {
        debugPrint('Error parsing placed order total: $e');
      }

      return true;
    } else {
      final msg = bodyData['message'] ?? 'Failed to place order';
      debugPrint(
        'confirmPlaceOrder failed: $msg (status: $status, success: $success)',
      );
      EasyLoading.showError(msg.toString());
      return false;
    }
  }

  /// Cancel and reset the flow back to a clean StackedScreen state
  void cancelAndReset() {
    try {
      final loc = Get.find<StackedLocationController>();
      loc.senderData.value = null;
      loc.receiverData.value = null;
    } catch (_) {}

    try {
      final vc = Get.find<StackedVehicleController>();
      vc.selectedVehicle.value = null;
      vc.selectedServices.clear();
      vc.calculationHistory.clear();
    } catch (_) {}

    try {
      final sched = Get.find<StackedScheduleController>();
      sched.setNow(true);
    } catch (_) {}

    // reset payment selector if present
    try {
      final pay = Get.find<StackedPaymentController>();
      pay.selectedIndex.value = 0;
      pay.selectedTitle.value = 'Select';
    } catch (_) {}

    // reset controller state
    lastOrderId = null;
    totalAmount.value = 0.0;
    totalFee.value = 0.0;
  }

  Future<void> applyPromoCode(String code) async {
    if (lastOrderId == null) {
      EasyLoading.showError('Order not created yet');
      return;
    }

    if (code.trim().isEmpty) {
      EasyLoading.showError('Enter promo code');
      return;
    }

    EasyLoading.show(status: 'Applying promo...');

    final res = await PromoService.applyPromo(
      orderId: lastOrderId!,
      promoCode: code.trim(),
    );

    EasyLoading.dismiss();

    final success = res['success'] as bool? ?? false;

    if (success) {
      final body = res['body'] as Map<String, dynamic>? ?? {};
      final data = body['data'] as Map<String, dynamic>? ?? {};

      /// Update totals from API
      totalAmount.value =
          double.tryParse(data['total_cost']?.toString() ?? '0') ?? 0;

      totalFee.value =
          double.tryParse(data['total_fee']?.toString() ?? '0') ?? 0;

      EasyLoading.showSuccess(body['message'] ?? 'Promo applied');

      Get.back(); // close promo dialog
    } else {
      EasyLoading.showError(res['body']?['message'] ?? 'Failed to apply promo');
    }
  }
}
