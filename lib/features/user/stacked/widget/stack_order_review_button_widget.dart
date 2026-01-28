import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/show_order_confirmation_dialog.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/order_confirmation_service.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/controller/controller.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class StackedOrderReviewButtonStatic extends StatelessWidget {

  const StackedOrderReviewButtonStatic({super.key, });

  @override
  Widget build(BuildContext context) {
    // Ensure the vehicle controller is available.
    final StackedVehicleController vehicleController = Get.find<StackedVehicleController>();
    
    // Ensure the order controller is available.
    final StackedOrderController orderController = Get.put(StackedOrderController());

    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 8),

          // Total Amount Display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (incl. GST):',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                Obx(() {
                  final oc = Get.find<StackedOrderController>();
                  final amountToShow = oc.totalFee.value > 0
                      ? oc.totalFee.value
                      : (oc.totalAmount.value > 0 ? oc.totalAmount.value : vehicleController.calculateTotal());

                  return Text(
                    '\$${amountToShow.toStringAsFixed(2)}',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }),
              ],
            ),
          ),

          Obx(() {
            final isReady = vehicleController.selectedVehicle.value != null;
            
            return FilledButton(
              onPressed: isReady
                  ? () async {
                      // Place order
                      await orderController.placeOrder(
                        locationController: Get.find(),
                        vehicleController: vehicleController,
                      );

                      // Proceed to fetch order details regardless of POST status
                      EasyLoading.show(status: 'Loading order details...');
                      
                      // 1️⃣ GET Order details
                      final orderRes = await OrderConfirmationService.getOrder(orderController.lastOrderId ?? 0);
                      final orderSuccess = orderRes['success'] as bool? ?? false;
                      final orderStatus = orderRes['statusCode'] as int? ?? 500;

                      if (!orderSuccess || (orderStatus != 200 && orderStatus != 201)) {
                        EasyLoading.dismiss();
                        EasyLoading.showError('Failed to load order details');
                        return;
                      }

                      final orderData = orderRes['body'] as Map<String, dynamic>? ?? {};
                      final orderActualData = orderData['data'] as Map<String, dynamic>? ?? {};
                      final totalCostRaw = orderActualData['total_cost'];
                      final totalCost = totalCostRaw is String ? double.tryParse(totalCostRaw) ?? 0.0 : (totalCostRaw as num?)?.toDouble() ?? 0.0;
                      debugPrint('💰 Order Total Cost: \$${totalCost}');

                      // 2️⃣ GET User profile
                      final userRes = await OrderConfirmationService.getUserProfile();
                      final userSuccess = userRes['success'] as bool? ?? false;
                      final userStatus = userRes['statusCode'] as int? ?? 500;

                      if (!userSuccess || (userStatus != 200 && userStatus != 201)) {
                        EasyLoading.dismiss();
                        EasyLoading.showError('Failed to load user profile');
                        return;
                      }

                      final userData = userRes['body'] as Map<String, dynamic>? ?? {};
                      final userActualData = userData['data'] as Map<String, dynamic>? ?? {};
                      final coinBalance = userActualData['current_coin_balance'] as num? ?? 0;
                      debugPrint('🪙 Current Coin Balance: $coinBalance');

                      // Update controller with fetched data
                      orderController.totalAmount.value = totalCost.toDouble();
                      orderController.userCoinBalance = coinBalance.toInt();

                      EasyLoading.dismiss();

                      // Show the server-backed confirmation dialog with server total and coin balance
                      showStackedOrderConfirmationDialog(orderController);
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isReady ? Colors.amber : Colors.grey.shade300,
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              child: Text(
                'Review Order',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isReady ? Colors.black : Colors.grey.shade600,
                ),
              ),
            );
          }),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
