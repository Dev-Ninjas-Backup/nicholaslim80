import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/rider/driver_preference/controller/driver_preference_controller.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class TowButtonSection extends StatelessWidget {
  const TowButtonSection({super.key, required this.ctrl});

  final DriverPreferenceController ctrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ctrl.cancelOrder();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              "Cancel Order",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 75),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.getriderBottomNavbarScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onboardingIndicatorActive,
              foregroundColor: AppColors.primaryFontColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(vertical: 6),
            ),
            child: Text(
              "Done",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
