import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/home/my_riders/widgets/delete_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/my_riders_controller.dart';
import 'add_riders_widget.dart';

class RidersListWidget extends StatelessWidget {
  const RidersListWidget({super.key, required this.controller});

  final MyRidersController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: controller.ridersList.length + 1,
          itemBuilder: (context, index) {
            // Add Rider Button
            if (index == controller.ridersList.length) {
              return Center(
                child: GestureDetector(
                  onTap: () => showAddRiderDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryButtonColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Add Rider',
                          style: getTextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final rider = controller.ridersList[index];
            final name = rider['name'] ?? '';
            final orderId = rider['order-id'] ?? '';
            final myRaiderId = rider['myRaiderId'] ?? 0; // ✅ Correct ID

            return Dismissible(
              key: Key(myRaiderId.toString()),
              direction: DismissDirection.startToEnd,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: Image.asset(IconPath.delete, height: 34, width: 34),
              ),

              // ✅ Confirm before delete
              confirmDismiss: (direction) async {
                final shouldDelete = await Get.dialog<bool>(
                  DeleteRiderDialog(
                    riderName: name,
                    onConfirm: () async {
                      // ✅ Call delete API
                      await controller.deleteRider(myRaiderId);
                      Get.back(result: true);
                    },
                  ),
                  barrierDismissible: false,
                );
                return shouldDelete ?? false;
              },

              onUpdate: (details) =>
                  controller.updateSwipeProgress(name, details.progress),

              child: Obx(() {
                final progress = controller.swipeProgress[name] ?? 0.0;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: Color.lerp(
                    AppColors.backgroungColor,
                    const Color.fromARGB(255, 230, 189, 28),
                    progress,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          rider['image'] ?? ImagePath.profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      style: getTextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      orderId,
                      style: getTextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: Obx(
                      () => IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: controller.loveState[name]! ? Colors.black : Colors.grey,
                        ),
                        onPressed: () => controller.toggleLove(name),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey, thickness: 1),
        );
      }),
    );
  }
}
