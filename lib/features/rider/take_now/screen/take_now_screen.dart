import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
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
            bottomPriceBox(),
            SizedBox(height: 26),

            // Fixed Slide-to-Take Button
            SlideToTakeButtonWidget(ctrl: ctrl, width: width),

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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

  Widget bottomPriceBox() {
    return Container(
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
          Spacer(),
          Container(width: 1, height: 24, color: Colors.grey.shade400),
          Spacer(),
          Text(
            "\$15.00 + \$10.50",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

//  Fixed SlideToTakeButtonWidget
class SlideToTakeButtonWidget extends StatelessWidget {
  final TakeNowController ctrl;
  final double width;

  const SlideToTakeButtonWidget({
    super.key,
    required this.ctrl,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = 68;
    final double leftGap = 12;
    final double maxDrag = width - buttonSize - leftGap;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 68,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.primaryButtonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 55),
                  Text(
                    "SLIDE TO TAKE",
                    style: getTextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              Text(
                "Now",
                style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Only the draggable button wrapped in Obx
        Obx(() {
          return Positioned(
            left: ctrl.dragX.value + leftGap,
            top: 12,
            bottom: 12,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                ctrl.dragX.value += details.delta.dx;
                if (ctrl.dragX.value < 0) ctrl.dragX.value = 0;
                if (ctrl.dragX.value > maxDrag) ctrl.dragX.value = maxDrag;
              },
              onHorizontalDragEnd: (_) {
                if (ctrl.dragX.value >= maxDrag * 0.9) {
                  ctrl.onSlideComplete();
                } else {
                  ctrl.resetSlide();
                }
              },
              child: Container(
                height: 38,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 6, top: 12, bottom: 12),
                  child: Image.asset(
                    IconPath.playicon,
                    height: 16,
                    width: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
