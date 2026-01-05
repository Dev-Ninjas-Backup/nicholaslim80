import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_app_bar_user.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/profile/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
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
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,

                itemCount: controller.profileItem.length,

                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.profileItem[index].title,
                                  style: getTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  controller.profileItem[index].subtitle,
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                //

                                //
                              },
                              child: Image.asset(
                                IconPath.editIcon,
                                height: 18,
                                width: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(thickness: 0.7),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
