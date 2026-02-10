import 'package:ZipBee/core/common/widgets/custom_button.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/loyalty_and_rewards_controller.dart';

class LoyaltyAndRewardsScreen extends StatelessWidget {
  const LoyaltyAndRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoyaltyAndRewardsController(), permanent: false);

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// ================= TOP BAR =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.onBack,
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const Text(
                    "Loyalty & Rewards",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: controller.onInfoTap,
                    child: const Icon(Icons.info_outline, size: 22),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// ================= POINTS BALANCE =================
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Your Points Balance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// POINTS
                    Obx(
                      () => Text(
                        controller.points.value.toString(),
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// DOLLAR VALUE
                    Obx(
                      () => Text(
                        "= \$${controller.dollarValue.value.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Points Earning History",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// ================= HISTORY CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() {
                  if (controller.history.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No history found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(controller.history.length, (index) {
                      final item = controller.history[index];
                      final isLast = index == controller.history.length - 1;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Order ${item["orderId"] ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Completed on ${item["date"] ?? ""}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            Divider(color: Colors.grey.shade300, thickness: 1),
                        ],
                      );
                    }),
                  );
                }),
              ),

              const SizedBox(height: 25),

              const Text(
                "How It Works",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 10),

              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• "),
                  Expanded(
                    child: Text(
                      "Each completed order earns 10 points for every S\$10 spent",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• "),
                  Expanded(
                    child: Text(
                      "Earn points on each order, which can be redeemed to your wallet as order credits",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              CustomButton(
                label: 'Convert points',
                onPressed: controller.showRedeemBottomSheet,
                color: AppColors.onboardingIndicatorActive,
                textColor: Colors.black,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
