import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/manage_payment_controller.dart';

class ManagePaymentScreen extends StatelessWidget {
  ManagePaymentScreen({super.key});

  final ManagePaymentController controller =
      Get.put(ManagePaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Manage Payment",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 25),

              /// ===============================
              /// CARD SECTION (Show only if exists)
              /// ===============================
              if (controller.hasCard.value) ...[
                _cardTile(),
                const SizedBox(height: 15),
                _divider(),
              ],

              /// ===============================
              /// ADD PAYMENT (ALWAYS SHOW)
              /// ===============================
              _addPaymentButton(),
              const SizedBox(height: 15),
              _divider(),

              const SizedBox(height: 25),

              /// ===============================
              /// MORE INFORMATION
              /// ===============================
              const Text(
                "More Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "For credit and debit card transactions, there will be authorisation hold to validate the card and this amount will be deducted against the final fare. Any unused amount will be returned after final payment.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  /// ===============================
  /// CARD TILE
  /// ===============================
  Widget _cardTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(IconPath.stripe, width: 40, height: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Card",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Default ****${controller.last4.value}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// ADD PAYMENT BUTTON
  /// ===============================
  Widget _addPaymentButton() {
    return GestureDetector(
      onTap: controller.onAddPayment,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            const Icon(Icons.add, size: 26),
            const SizedBox(width: 10),
            Text(
              controller.hasCard.value
                  ? "Add another payment method"
                  : "Add payment method",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// DIVIDER
  /// ===============================
  Widget _divider() {
    return const Divider(
      thickness: 0.8,
      color: Colors.black26,
    );
  }
}
