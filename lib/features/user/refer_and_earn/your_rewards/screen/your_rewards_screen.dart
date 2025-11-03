import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_button.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/your_rewards/controller/your_rewards_controller.dart';

class YourRewardsScreen extends StatelessWidget {
  const YourRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final YourRewardsController ctrl = Get.put(YourRewardsController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Your Rewards",
          style: getTextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.info_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Obx(
              () => Column(
                children: [
                  Text(
                    'Total credits earned',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${ctrl.totalCredits}',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '= \$${ctrl.currencyValue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'For every successful referral, you receive 20 credits\n'
              'towards your next order',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Referral History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: ctrl.referralHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final item = ctrl.referralHistory[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You earned on ${item['date']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Underline
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(top: 4),
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 10),
            CustomButton(
              label: "Redeem credits to wallet",
              onPressed: () {},
              color: AppColors.primaryButtonColor,
              textColor: AppColors.primaryFontColor,
            ),
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
