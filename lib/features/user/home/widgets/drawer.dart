import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


Drawer drawer(HomeController controller) {
  return Drawer(
    backgroundColor: Color(0xFFFFEA96),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17, left: 16, right: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),

              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.clear, size: 24),
              ),

              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ListView.builder(
                  itemCount: controller.drawerItem.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    var item = controller.drawerItem[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 38),
                      child: GestureDetector(
                        onTap: controller.drawerItem[index].ontap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(item.iconUrl, height: 24, width: 24),
                                SizedBox(width: 10),
                                Text(
                                  item.iconname,
                                  style: getTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                        
                            GestureDetector(
                              onTap: controller.drawerItem[index].ontap,
                        
                              child: Icon(Icons.arrow_forward_ios, size: 24),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        Spacer(),
        GestureDetector(
          onTap: () {
            
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.onboardingIndicatorActive,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(IconPath.carIcon, height: 30, width: 30),
                Text(
                  "Become a Rider",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        SizedBox(height: 64),
      ],
    ),
  );
}
