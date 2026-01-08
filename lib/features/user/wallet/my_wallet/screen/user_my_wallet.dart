import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/wallet/loyalty_and_rewards/screen/loyalty_and_rewards_screen.dart';
import 'package:ZipBee/features/user/wallet/manage_payment/screen/manage_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_my_wallet_controller.dart';
import '../widgets/my_wallet_upper_section.dart';

class UserMyWallet extends StatelessWidget {
  UserMyWallet({super.key});

  final controller = Get.put(UserMyWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyWalletUpperSection(controller: controller),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(ManagePaymentScreen()),
                    child: rowItem("Manage Payment Methods"),
                  ),
                  const Divider(),

                  GestureDetector(
                    onTap: () => Get.to(LoyaltyAndRewardsScreen()),
                    child: rowItem("Loyalty & Rewards"),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Wallet recent transactions",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const CircularProgressIndicator();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recentTransactionList.length,
                      itemBuilder: (_, index) {
                        final item = controller.recentTransactionList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: getTextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    item['orderId'],
                                    style: getTextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                item['amount'],
                                style: getTextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.subtitleFontColor,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}
