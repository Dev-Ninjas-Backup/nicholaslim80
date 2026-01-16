import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/common/widgets/custom_app_bar_user.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/notification/controller/user_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                              onTap: () => controller.changeTab(index),
                              child: Container(
                                margin:  EdgeInsets.only(right: 10),
                                padding:  EdgeInsets.symmetric(
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
                     SizedBox(height: 40),

                    controller.isLoading.value &&
                            controller.notificationList.isEmpty
                        ?  Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics:  NeverScrollableScrollPhysics(),
                            itemCount: controller.notificationList.length,
                            itemBuilder: (_, index) {
                              final item = controller.notificationList[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                                           Icon(
                                            Icons.circle,
                                            size: 12,
                                            color: AppColors
                                                .onboardingIndicatorActive,
                                          ),
                                           SizedBox(width: 8),
                                          Text(
                                            item.title,
                                            style: getTextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                       SizedBox(height: 12),
                                      Text(
                                        item.subTitle,
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color:  Color(0xFF6B6B6B),
                                        ),
                                      ),
                                       SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.date,
                                            style: getTextStyle(
                                              fontSize: 12,
                                              color:  Color(0xFF6B6B6B),
                                            ),
                                          ),
                                          Text(
                                            item.time,
                                            style: getTextStyle(
                                              fontSize: 12,
                                              color:  Color(0xFF6B6B6B),
                                            ),
                                          ),
                                        ],
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
            ),
          ],
        ),
      ),
    );
  }
}
