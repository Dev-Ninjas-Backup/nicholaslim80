import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/home/my_riders/controller/my_riders_controller.dart';

class RidersListWidget extends StatelessWidget {
  const RidersListWidget({super.key, required this.controller});

  final MyRidersController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 28),
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.only(bottom: 20),
          itemCount: controller.ridersList.length + 1, // +1 for the button
          itemBuilder: (context, index) {
            // Render button as the last item
            if (index == controller.ridersList.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: () {
                      // Action for See All Riders
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryButtonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      'See All Riders',
                      style: getTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }

            final rider = controller.ridersList[index];
            final name = rider['name'] ?? '';
            final id = rider['order-id'] ?? '';

            return Dismissible(
              key: Key(id),
              direction: DismissDirection.startToEnd,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                controller.ridersList.removeAt(index);
                controller.loveState.remove(name);

                Get.snackbar(
                  'Deleted',
                  '$name has been removed',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
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
                  id,
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
                      color: controller.loveState[name]!
                          ? Colors.black
                          : Colors.grey,
                    ),
                    onPressed: () {
                      controller.toggleLove(name);
                    },
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey, thickness: 1),
        ),
      ),
    );
  }
}
