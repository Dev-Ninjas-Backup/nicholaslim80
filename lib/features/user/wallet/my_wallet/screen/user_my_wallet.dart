import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/wallet/my_wallet/controller/user_my_wallet_controller.dart';
import 'package:nicholaslim80/routes/app_routes.dart';
import '../widgets/my_wallet_upper_section.dart';

class UserMyWallet extends StatelessWidget {
  final controller = Get.put(UserMyWalletController());
  UserMyWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,

      body: SingleChildScrollView(
        child: Column(
          children: [
            MyWalletUpperSection(controller: controller),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.getuserAddFund());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Payment Methods",
                          style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleFontColor,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Loyalty & Rewards",
                          style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleFontColor,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Wallet recent transactions",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),

                  ListView.builder(
                    itemCount: controller.recentTransactionList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = controller.recentTransactionList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: .75,
                              color: Color(0xFF969696),
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: getTextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    item.orderID,
                                    style: getTextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.ammount,
                                style: getTextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
