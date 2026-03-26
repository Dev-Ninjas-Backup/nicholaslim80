import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/order_confirmation_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/show_order_confirmation_dialog.dart';
import 'package:ZipBee/features/user/vehicle_type/controller/controller.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class StackedOrderReviewButtonStatic extends StatelessWidget {
  const StackedOrderReviewButtonStatic({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Use Get.find() NOT Get.put() inside build
    final vehicleController = Get.find<StackedVehicleController>();
    final orderController = Get.find<StackedOrderController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 8),

          /// ================= TOTAL DISPLAY =================
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
                  final total = orderController.totalCost.value;
                  final isLoading = orderController.isFetchingTotal.value;

                  if (isLoading) {
                    return Row(
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.amber,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text("Loading..."),
                      ],
                    );
                  }

                  return Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: total > 0 ? Colors.black : Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ),

          /// ================= REVIEW BUTTON =================
          Obx(() {
            final isReady = vehicleController.selectedVehicle.value != null;

            return FilledButton(
              onPressed: isReady
                  ? () async {
                      final savedTotal = orderController.totalCost.value;

                      orderController.isFetchingTotal.value = true;

                      try {
                        /// ---------- REFRESH ORDER ----------
                        if (orderController.lastOrderId != null) {
                          final res = await OrderConfirmationService.getOrder(
                            orderController.lastOrderId!,
                          );

                          final data =
                              (res['body']?['data'] as Map<String, dynamic>?) ??
                              {};

                          final raw = data['total_cost'];

                          final latestTotal = raw is String
                              ? double.tryParse(raw)
                              : (raw as num?)?.toDouble();

                          // ✅ Only update if valid
                          if (latestTotal != null && latestTotal > 0) {
                            orderController.totalCost.value = latestTotal;
                          }
                        }

                        /// ---------- PLACE ORDER ----------
                        await orderController.placeOrder(
                          locationController: Get.find(),
                          vehicleController: vehicleController,
                        );

                        EasyLoading.show(status: 'Loading order details...');

                        /// ---------- GET ORDER DETAILS ----------
                        final orderRes =
                            await OrderConfirmationService.getOrder(
                              orderController.lastOrderId ?? 0,
                            );

                        final orderData =
                            orderRes['body']?['data']
                                as Map<String, dynamic>? ??
                            {};

                        final rawTotal = orderData['total_cost'];

                        final confirmedTotal = rawTotal is String
                            ? double.tryParse(rawTotal) ?? savedTotal
                            : (rawTotal as num?)?.toDouble() ?? savedTotal;

                        orderController.totalCost.value = confirmedTotal;
                        orderController.totalAmount.value = confirmedTotal;

                        /// ---------- GET USER PROFILE ----------
                        final userRes =
                            await OrderConfirmationService.getUserProfile();

                        final userData =
                            userRes['body']?['data'] as Map<String, dynamic>? ??
                            {};

                        final walletBalance =
                            (userData['currentWalletBalance'] as num?)
                                ?.toDouble() ??
                            0.0;

                        EasyLoading.dismiss();

                        showStackedOrderConfirmationDialog(orderController);
                      } catch (e) {
                        EasyLoading.dismiss();

                        // ✅ Restore previous total safely
                        orderController.totalCost.value = savedTotal;
                        orderController.totalAmount.value = savedTotal;
                      } finally {
                        orderController.isFetchingTotal.value = false;
                      }
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isReady ? Colors.amber : Colors.grey.shade300,
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
