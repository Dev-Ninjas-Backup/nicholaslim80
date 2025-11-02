// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/rider/driver_preference/distance_radius/controller/distance_radius_controller.dart';

class DistanceRadiusScreen extends StatelessWidget {
  final DistanceRadiusController ctrl = Get.put(DistanceRadiusController());

  DistanceRadiusScreen({super.key});

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(ImagePath.trackmap, fit: BoxFit.cover),
          ),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 246,
                  height: 246,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
                Icon(
                  Icons.location_on,
                  size: 48,
                  color: AppColors.onboardingIndicatorActive,
                ),
              ],
            ),
          ),

          // Bottom radius controller
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: ctrl.decreaseRadius,
                          borderRadius: BorderRadius.circular(40),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: AppColors.onboardingIndicatorActive,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.transparent,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: AppColors.primaryFontColor,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 40),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${ctrl.radiusKm.value.toInt()} Km',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),

                        SizedBox(width: 40),

                        InkWell(
                          onTap: ctrl.increaseRadius,
                          borderRadius: BorderRadius.circular(40),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: AppColors.onboardingIndicatorActive,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.transparent,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.primaryFontColor,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: AppColors.onboardingIndicatorActive,
                      minimumSize: Size(290, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => ctrl.saveRadius(context),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
