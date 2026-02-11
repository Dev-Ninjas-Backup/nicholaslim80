import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/manage_payment_controller.dart';

class ManagePaymentScreen extends StatelessWidget {
  ManagePaymentScreen({super.key});

  final controller = Get.put(ManagePaymentController());

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// 🔥 Stripe Card (Reactive)
            Obx(
              () => paymentTile(
                icon: IconPath.stripe,
                title: "Card",
                subtitle: controller.hasCard.value
                    ? "Default ****${controller.last4.value}"
                    : "Add your card",
                onTap: controller.onStripeTap,
              ),
            ),

            const SizedBox(height: 10),
            divider(),

            paymentTile(
              icon: IconPath.nets,
              title: "NETS",
              subtitle: "Add NETS Bank Card here",
              onTap: controller.onNetsTap,
            ),

            divider(),

            Obx(
              () => paymentTile(
                icon: IconPath.stripe,
                title: "Card Card",
                subtitle: controller.hasCard.value
                    ? "Default ****${controller.last4.value}"
                    : "No card added",
                onTap: controller.onStripeTap,
              ),
            ),

            divider(),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: controller.onAddPayment,
              child: Row(
                children: const [
                  Icon(Icons.add, size: 26),
                  SizedBox(width: 10),
                  Text(
                    "Add payment method",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "More Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "For credit and debit card transactions, there will be authorisation hold to validate the card and this amount will be deducted against the final fare. Any unused amount will be returned to you after final payment.",
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 40, height: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(thickness: .8, color: Colors.black26),
    );
  }
}
