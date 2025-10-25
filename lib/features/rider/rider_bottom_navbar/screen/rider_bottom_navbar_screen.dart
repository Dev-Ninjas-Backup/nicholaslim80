import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/rider/rider_account/screen/rider_account_screen.dart';
import 'package:nicholaslim80/features/rider/rider_bottom_navbar/controller/rider_bottom_navbar_controller.dart';
import 'package:nicholaslim80/features/rider/rider_home/screen/rider_home_screen.dart';
import 'package:nicholaslim80/features/rider/rider_incentives/screen/incentives_screen.dart';
import 'package:nicholaslim80/features/rider/rider_records/screen/records_screen.dart';

class RiderBottomNavbarScreen extends StatelessWidget {
  RiderBottomNavbarScreen({super.key});

  final RiderBottomNavbarController controller = Get.put(
    RiderBottomNavbarController(),
  );

  final List<Widget> screens = [
    RiderHomeScreen(),
    RecordsScreen(),
    IncentivesScreen(),
    RiderAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: screens[controller.currentIndex.value],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.onboardingIndicatorActive,
              unselectedItemColor: AppColors.subtitleFontColor,
              showUnselectedLabels: true,
              selectedLabelStyle: getTextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: 'Records',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard_outlined),
                  activeIcon: Icon(Icons.card_giftcard),
                  label: 'Incentives',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
