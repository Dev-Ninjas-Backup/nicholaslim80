import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/rider/take_now/widgets/bottom_price_box_widget.dart';
import 'package:nicholaslim80/features/rider/take_now/widgets/location_tile_widget.dart';
import 'package:nicholaslim80/features/rider/take_now/widgets/slide_take_button_widget.dart';
import '../controller/take_now_controller.dart';

class TakeNowScreen extends StatelessWidget {
  const TakeNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TakeNowController ctrl = Get.put(TakeNowController());
    final width = MediaQuery.of(context).size.width - 32; // account for padding

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.onboardingIndicatorActive,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Image.asset(IconPath.exparess, width: 30, height: 30),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Car",
                  style: getTextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "EXPRESS",
                      style: getTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.flash_on, color: Colors.orange, size: 18),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationTile(
              title: "Punggol",
              subtitle: "Block 665 Punggol Drive #15-32\nSingapore 822665",
              distance: "3.1Km | 5 Mins",
              isPickup: true,
            ),
            SizedBox(height: 10),
            // location tile
            LocationTile(
              title: "Boon Keng",
              subtitle: "32 Boon Keng Ave 4 #04-144\nSingapore 530032",
              distance: "8.9Km | 13 Mins",
              isPickup: false,
            ),
            SizedBox(height: 20),
            Text(
              "Remarks:",
              style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            SizedBox(height: 6),
            Text(
              "Please send it to Mr. Alex. Contact ********\n(Censored the mobile number)",
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            BottomPriceBox(),
            SizedBox(height: 26),

            // Fixed Slide-to-Take Button
            SlideToTakeButtonWidget(ctrl: ctrl, width: width),

            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
