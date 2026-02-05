import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

// Payment Option Model
class StackedPaymentOption {
  final String title;
  final String subtitle;
  final String? imageAsset;

  StackedPaymentOption({required this.title, required this.subtitle, this.imageAsset});
}

// -------------------
// Payment Controller
// -------------------
class StackedPaymentController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedTitle = "Select".obs;
  var walletBalance = 0.0.obs;
  String? selectedPaymentMethodId; // Store payment method ID from Stripe
}

// -------------------
// Payment Selection Widget
// -------------------
class StackedPaymentSelectionWidget extends StatelessWidget {
  final List<StackedPaymentOption> options;
  final StackedPaymentController controller;
  final double orderAmount;

  const StackedPaymentSelectionWidget({
    super.key,
    required this.options,
    required this.controller,
    required this.orderAmount,
  });

  /// Handle payment method selection
  Future<void> _handlePaymentSelection(int index, StackedPaymentOption option) async {
    controller.selectedIndex.value = index;
    controller.selectedTitle.value = option.title;

    // Just select the payment method - don't process payment yet
    if (option.title == "Stripe") {
      debugPrint('➡️ Stripe selected - Payment will process on Place Order');
      controller.selectedPaymentMethodId = 'stripe';
      EasyLoading.showInfo('Stripe selected');
      Get.back();
    } else if (option.title == "Wallet") {
      debugPrint('✅ Wallet selected');
      controller.selectedPaymentMethodId = 'wallet';
      EasyLoading.showInfo('Wallet selected');
      Get.back();
    } else if (option.title == "Cash") {
      debugPrint('✅ Cash selected');
      controller.selectedPaymentMethodId = 'cash';
      EasyLoading.showInfo('Cash selected');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.asMap().entries.map((entry) {
        int index = entry.key;
        StackedPaymentOption option = entry.value;

        return Column(
          children: [
            Obx(
              () => ListTile(
                leading: option.imageAsset != null
                    ? Image.asset(option.imageAsset!, width: 32, height: 32)
                    : Image.asset(IconPath.arrowBackIcon),
                title: Text(
                  option.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  option.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: GestureDetector(
                  onTap: () => _handlePaymentSelection(index, option),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.selectedIndex.value == index
                            ? Colors.yellow
                            : Colors.black,
                        width: 2,
                      ),
                    ),
                    child: controller.selectedIndex.value == index
                        ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow,
                        ),
                      ),
                    )
                        : null,
                  ),
                ),
                onTap: () => _handlePaymentSelection(index, option),
              ),
            ),
            if (index != options.length - 1) Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }
}

// -------------------
// Selector Button Widget
// -------------------
class StackedPaymentMethodSelector extends StatelessWidget {
  final List<StackedPaymentOption> options;
  final double orderAmount;
  final StackedPaymentController controller = Get.put(StackedPaymentController());

  StackedPaymentMethodSelector({
    super.key,
    required this.options,
    required this.orderAmount,
  });

  void openSelectorSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: StackedPaymentSelectionWidget(
          options: options,
          controller: controller,
          orderAmount: orderAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openSelectorSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Obx(
              () => Text(
                controller.selectedTitle.value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
