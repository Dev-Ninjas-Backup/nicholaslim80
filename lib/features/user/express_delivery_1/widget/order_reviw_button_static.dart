import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/express_delivery_1/controller/express_controller_1.dart';
import 'package:ZipBee/features/user/stacked/show_order_confirmation/show_order_confirmation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderReviwButtonStatic extends StatelessWidget {
  final ExpressDeliveryMain controller = Get.find<ExpressDeliveryMain>();

  OrderReviwButtonStatic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      padding: const EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 8),
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
                Obx(
                  () => Text(
                    controller.totalAmount.value.toString(),
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
      Obx(
  () => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: controller.totalAmount.value > 0
          ? Colors.amber
          : Colors.grey,
    ),
    onPressed: controller.totalAmount.value > 0
    ? () {
        showOrderConfirmationDialog(controller); // ✅ function call kore dialog show
      }
    : null,
 // disables the button when value <= 0
    child: const Text(
      'Review Order',
      style: TextStyle(color: Colors.black),
    ),
  ),
),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
