import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/common/widgets/custom_app_bar_user.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/user_my_wallet_controller.dart';

class MyWalletUpperSection extends StatelessWidget {
  const MyWalletUpperSection({super.key, required this.controller});

  final UserMyWalletController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 26),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF5),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          children: [
            CustomAppBarUser(
              title: "My Wallet",
              onTap: () => Get.offNamed(AppRoutes.bottomNavbarScreen),
              style: getTextStyle(),
            ),

            const SizedBox(height: 16),
            const Text("Current Balance"),

            Obx(
              () => Text(
                "\$${controller.currentBalance.value}",
                style: getTextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => Row(
                children: [
                  walletButton(
                    title: "Add Funds",
                    selected: controller.selectFundsOrRedeen.value == 0,
                    onTap: () {
                      controller.selectFundsOrRedeen.value = 0;
                      Get.toNamed(AppRoutes.getuserAddFund());
                    },
                  ),
                  const SizedBox(width: 20),
                  walletButton(
                    title: "Redeem Points",
                    selected: controller.selectFundsOrRedeen.value == 1,
                    onTap: () => controller.selectFundsOrRedeen.value = 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget walletButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryButtonColor
                : const Color(0xFFFFFAE6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: getTextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.black : Colors.brown,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
