import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/common/widgets/custom_app_bar_user.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/notification/controller/user_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class UserNotification extends StatelessWidget {
  const UserNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserNotificationController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: Column(
        children: [
          CustomAppBarUser(title: "Notifications", style: getTextStyle()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Obx(
                () => Column(
                  children: [
                    /// ------------------- Tabs -------------------
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
                                child: Text(
                                  controller.notificationTabs[index],
                                  style: getTextStyle(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ------------------- Notification List -------------------
                    Expanded(
                      child:
                          controller.isLoading.value &&
                              controller.notificationList.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: controller.notificationList.length,
                              itemBuilder: (_, index) {
                                final item = controller.notificationList[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Slidable(
                                    key: ValueKey(item.id),

                                    /// only small reveal
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) {
                                            controller.confirmDelete(item.id);
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ],
                                    ),

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
                                              Icon(
                                                Icons.circle,
                                                size: 12,
                                                color: AppColors
                                                    .onboardingIndicatorActive,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  item.title ?? "",
                                                  style: getTextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            item.subTitle ?? "",
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
                                                item.date ?? "",
                                                style: getTextStyle(
                                                  fontSize: 12,
                                                  color: const Color(
                                                    0xFF6B6B6B,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                item.time ?? "",
                                                style: getTextStyle(
                                                  fontSize: 12,
                                                  color: const Color(
                                                    0xFF6B6B6B,
                                                  ),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
