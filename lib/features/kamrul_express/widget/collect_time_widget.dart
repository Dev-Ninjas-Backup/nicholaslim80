import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/kamrul_express/controller/kamrul_express_controller.dart';

final controller = Get.find<KamrulExpressController>();

Widget collectTime() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Collect time",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 12),

      Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.toggleCollect(true),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: controller.collectNow.value
                          ? AppColors.onboardingIndicatorActive
                          : Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Now",
                        style: getTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 90),
                      Icon(
                        Icons.check_circle,
                        color: controller.collectNow.value
                            ? Colors.green
                            : Colors.transparent,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: GestureDetector(
                onTap: () => controller.toggleCollect(false),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: !controller.collectNow.value
                          ? AppColors.onboardingIndicatorActive
                          : Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Schedule",
                            style: getTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Pick Date and Time",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 30),

                      Icon(
                        Icons.check_circle,
                        color: !controller.collectNow.value
                            ? Colors.green
                            : Colors.transparent,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
