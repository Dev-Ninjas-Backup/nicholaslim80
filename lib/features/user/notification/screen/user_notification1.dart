import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_app_bar_user.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/notification/controller/user_notification_controller.dart';

import '../../../orders/active_order_details/screen/active_order_details_screen.dart';

class UserNotification extends StatelessWidget {
  const UserNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserNotificationController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBarUser(title: "Notifications", style: getTextStyle()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Obx(
                () => Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.notificationTabs.length,
                          (index) {
                            final isSelected =
                                controller.selectNotificationListIndex.value ==
                                index;
                            return GestureDetector(
                              onTap: () {
                                controller.selectNotificationListIndex.value =
                                    index;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.subtitleFontColor,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected
                                      ? AppColors.onboardingIndicatorActive
                                      : Colors.transparent,
                                ),
                                child: Text(controller.notificationTabs[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Notification List
                    controller.isLoading.value &&
                            controller.notificationList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.notificationList.length,
                            itemBuilder: (_, index) {
                              final item = controller.notificationList[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(ActiveOrderDetailsScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.subtitleFontColor,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              IconPath.ellipsIcon,
                                              height: 12,
                                              width: 12,
                                              color: AppColors
                                                  .onboardingIndicatorActive,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              item.title,
                                              style: getTextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item.subTitle,
                                          style: getTextStyle(
                                            fontSize: 12,
                                            color: const Color(0xFF6B6B6B),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.date,
                                              style: getTextStyle(
                                                fontSize: 12,
                                                color: const Color(0xFF6B6B6B),
                                              ),
                                            ),
                                            Text(
                                              item.time,
                                              style: getTextStyle(
                                                fontSize: 12,
                                                color: const Color(0xFF6B6B6B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
