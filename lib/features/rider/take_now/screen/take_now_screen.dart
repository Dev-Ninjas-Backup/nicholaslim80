import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/rider/take_now/controller/take_now_controller.dart';

class TakeNowScreen extends StatelessWidget {
  const TakeNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TakeNowController ctrl = Get.put(TakeNowController());
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.onboardingIndicatorActive,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
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
            locationTile(
              title: "Punggol",
              subtitle: "Block 665 Punggol Drive #15-32\nSingapore 822665",
              distance: "3.1Km | 5 Mins",
              isPickup: true,
            ),
            SizedBox(height: 10),
            locationTile(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Image.asset(IconPath.exparess, width: 24),
                  SizedBox(width: 8),

                  Text("8.9KM", style: TextStyle(fontWeight: FontWeight.w600)),

                  SizedBox(width: 8),
                  Spacer(),

                  Container(width: 1, height: 24, color: Colors.grey.shade400),
                  Spacer(),

                  SizedBox(width: 8),

                  // Price text
                  Text(
                    "\$15.00 + \$10.50",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Obx(
              () => ctrl.isSlideCompleted.value
                  ? nowButton()
                  : slideToTakeButton(ctrl, width),
            ),
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget locationTile({
    required String title,
    required String subtitle,
    required String distance,
    required bool isPickup,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side (Icon + Title + Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Left icon container
                    SizedBox(
                      width: 30,
                      height: 30,

                      child: Center(
                        child: Image.asset(
                          isPickup
                              ? IconPath.locationBlue
                              : IconPath.locationRed,
                          width: 16,
                          height: 16,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 2),

                    // Title text
                    Text(
                      title,
                      style: getTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    subtitle,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                distance.split('|')[0].trim(),
                style: getTextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6),

              Container(width: 1, height: 14, color: Colors.grey),

              SizedBox(width: 6),
              if (distance.split('|').length > 1)
                Text(
                  distance.split('|')[1].trim(),
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget slideToTakeButton(TakeNowController ctrl, double width) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        ctrl.onSlideComplete();
      },
      child: Container(
        width: width,
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.onboardingIndicatorActive,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "SLIDE TO TAKE",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nowButton() {
    return Container(
      height: 65,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "NOW",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
