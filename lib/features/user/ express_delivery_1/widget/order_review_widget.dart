import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class OrderReviewController extends GetxController {
  RxDouble total = 0.0.obs;

  // Example: update total dynamically
  void updateTotal(double value) {
    total.value = value;
  }
}

class OrderReviewWidget extends StatelessWidget {
  final bool isButtonEnabled;

  const OrderReviewWidget({
    super.key,
    this.isButtonEnabled = false,
    required int total,
  });

  @override
  Widget build(BuildContext context) {
    final OrderReviewController controller = Get.put(OrderReviewController());

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Total Display
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (incl. GST)',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                Text(
                  'S\$${controller.total.value.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          /// Review Order Button
          Flexible(
            child: FilledButton(
              onPressed: isButtonEnabled
                  ? () {
                      // Navigate to review order screen with total
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? Colors.amber
                    : CupertinoColors.inactiveGray,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Review order',
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
