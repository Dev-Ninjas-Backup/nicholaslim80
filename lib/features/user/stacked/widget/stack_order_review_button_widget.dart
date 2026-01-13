import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/show_order_confirmation_dialog.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/controller/controller.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/material.dart';
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
            child: Obx(() => Column(
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
                Text(
                  '\$${vehicleController.calculateTotal().toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
          ),

          Obx(() {
            final isReady = vehicleController.selectedVehicle.value != null;
            
            return FilledButton(
              onPressed: isReady
                  ? () async {
                      // call placeOrder which will POST and GET the order, set controller.totalAmount
                      final ok = await orderController.placeOrder(
                        locationController: Get.find(),
                        vehicleController: vehicleController,
                      );

                      if (ok) {
                        // Show the server-backed confirmation dialog with server total
                        showStackedOrderConfirmationDialog(orderController);
                      } else {
                        // Show error
                        debugPrint('Order placement failed');
                      }
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
