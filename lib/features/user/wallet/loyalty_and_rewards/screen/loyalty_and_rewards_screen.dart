import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/widgets/custom_button.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import '../controller/loyalty_and_rewards_controller.dart';

class LoyaltyAndRewardsScreen extends StatelessWidget {
  const LoyaltyAndRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoyaltyAndRewardsController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              /// ======================
              /// TOP BAR
              /// ======================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.onBack,
                    child: Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Text(
                    "Loyalty & Rewards",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: controller.onInfoTap,
                    child: Icon(Icons.info_outline, size: 22),
                  ),
                ],
              ),

              SizedBox(height: 25),

              /// ======================
              /// POINTS BALANCE
              /// ======================
              Center(
                child: Column(
                  children: [
                    Text(
                      'Your Points Balance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// points
                    Obx(
                      () => Text(
                        controller.points.value.toString(),
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 4),

                    /// dollar value
                    Obx(
                      () => Text(
                        "= \$${controller.dollarValue.value.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),

              SizedBox(height: 10),

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

              SizedBox(height: 15),

              /// ======================
              /// HISTORY CARD (ONLY THIS NEEDS Obx)
              /// ======================
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => Column(
                    children: controller.history.map((item) {
                      bool isLast = item == controller.history.last;

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Order ${item["orderId"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Completed on ${item["date"]}",
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
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 25),

              Text(
                "How It Works",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 10),

              Row(
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

              SizedBox(height: 6),

              Row(
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

              SizedBox(height: 70),
              CustomButton(
                label: 'Convert points',
                onPressed: controller.showRedeemBottomSheet,
                color: AppColors.onboardingIndicatorActive,
                textColor: Colors.black,
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
