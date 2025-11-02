import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar_user.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../controller/user_my_wallet_controller.dart';

class MyWalletUpperSection extends StatelessWidget {
  const MyWalletUpperSection({super.key, required this.controller});

  final UserMyWalletController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 26),
      decoration: BoxDecoration(
        color: Color(0xFFFFFDF5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withValues(alpha: .24),
            spreadRadius: -1,
            blurRadius: 9,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          children: [
            CustomAppBarUser(
              title: "My Wallet",
              onTap: () {
                Get.offNamed(AppRoutes.bottomNavbarScreen);
              },
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                "Current Balance",
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                "S\$350.00",
                style: getTextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 20),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.selectFundsOrRedeen.value = 0;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectFundsOrRedeen.value == 0
                              ? AppColors.primaryButtonColor
                              : Color(0xFFFFFAE6),

                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000).withValues(alpha: .24),
                              spreadRadius: -1,
                              blurRadius: 9,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Add Funds",
                            style: getTextStyle(
                              color: controller.selectFundsOrRedeen.value == 0
                                  ? AppColors.fontColor
                                  : Color(0xFF9C7C00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.selectFundsOrRedeen.value = 1;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectFundsOrRedeen.value == 1
                              ? AppColors.primaryButtonColor
                              : Color(0xFFFFFAE6),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000).withValues(alpha: .24),
                              spreadRadius: -1,
                              blurRadius: 9,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Redeem Points",
                            style: getTextStyle(
                              color: controller.selectFundsOrRedeen.value == 1
                                  ? AppColors.fontColor
                                  : Color(0xFF9C7C00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
