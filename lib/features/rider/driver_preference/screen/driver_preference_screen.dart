// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/rider/driver_preference/controller/driver_preference_controller.dart';
import 'package:nicholaslim80/features/rider/driver_preference/widget/button_widget.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class DriverPreferenceScreen extends StatelessWidget {
  DriverPreferenceScreen({super.key});

  final DriverPreferenceController ctrl = Get.put(DriverPreferenceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primaryFontColor,
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            "Offline",
            style: TextStyle(
              color: AppColors.primaryFontColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Obx(
              () => Switch(
                value: ctrl.isOffline.value,
                onChanged: ctrl.toggleOffline,
                activeThumbColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Map Placeholder---------->>>
          Container(
            height: 374,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(ImagePath.trackmap),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryFontColor.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_pin,
                color: AppColors.onboardingIndicatorActive,
                size: 40,
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preference Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Preference",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Text(
                    "Set your Auto popup and Distance Radius nearby order",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Auto Popup
                  Obx(
                    () => Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.onboardingIndicatorActive,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: AppColors.primaryFontColor,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Auto Popup",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Switch(
                          value: ctrl.isAutoPopup.value,
                          onChanged: ctrl.toggleAutoPopup,
                          activeThumbColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Distance Radius Row
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.getdistanceRadiusScreen());
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.onboardingIndicatorActive,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.primaryFontColor,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Distance Radius",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.primaryFontColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 70),
                  TowButtonSection(ctrl: ctrl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
