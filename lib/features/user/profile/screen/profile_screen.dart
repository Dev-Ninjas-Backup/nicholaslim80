import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/common/widgets/custom_app_bar_user.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomAppBarUser(
                title: "Profile",
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    ImagePath.profileImage,
                    height: 34,
                    width: 34,
                  ),
                ),
                style: getTextStyle(),
              ),
              SizedBox(height: 36),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.profileItem.length,
                    itemBuilder: (_, index) {
                      return Obx(() {
                        final isEditing =
                            controller.editingIndex.value == index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.profileItem[index].title,
                                          style: getTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        isEditing
                                            ? TextFormField(
                                                controller: controller
                                                    .getControllerForIndex(
                                                      index,
                                                    ),
                                                autofocus: true,
                                                keyboardType: index == 1
                                                    ? TextInputType.emailAddress
                                                    : index == 2
                                                    ? TextInputType.phone
                                                    : TextInputType.text,
                                                style: getTextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                          ),
                                                      border: InputBorder.none,
                                                    ),
                                              )
                                            : Text(
                                                controller
                                                    .profileItem[index]
                                                    .subtitle,
                                                style: getTextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  isEditing
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: controller.cancelEditing,
                                              child: const Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () {
                                                // Call API to update
                                                controller.updateUserProfile(
                                                  username: controller
                                                      .usernameController
                                                      .text,
                                                  email: controller
                                                      .emailController
                                                      .text,
                                                  phone: controller
                                                      .phoneController
                                                      .text,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.check,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () =>
                                              controller.startEditing(index),
                                          child: Image.asset(
                                            IconPath.editIcon,
                                            height: 18,
                                            width: 18,
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(thickness: 0.7),
                            ],
                          ),
                        );
                      });
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
