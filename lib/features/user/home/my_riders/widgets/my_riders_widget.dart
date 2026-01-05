import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/home/my_riders/controller/my_riders_controller.dart';
import 'package:nicholaslim80/features/user/home/my_riders/widgets/add_riders_widget.dart';

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
                child: GestureDetector(
                  onTap: () {
                    // Action for See All Riders
                  },
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showAddRiderDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryButtonColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(width: 8),
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
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.backgroungColor,
                child: Image.asset(IconPath.delete, height: 34, width: 34),
              ),
              onUpdate: (details) =>
                  controller.updateSwipeProgress(name, details.progress),
              onDismissed: (_) {
                controller.ridersList.removeAt(index);
                controller.loveState.remove(name);
              },
              child: Obx(() {
                final progress = controller.swipeProgress[name] ?? 0.0;

                return AnimatedContainer(
                  duration: Duration(microseconds: 500),
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
              }),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.grey, thickness: 1),
        ),
      ),
    );
  }
}
