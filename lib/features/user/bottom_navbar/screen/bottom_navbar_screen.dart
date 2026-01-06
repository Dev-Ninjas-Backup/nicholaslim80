import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/bottom_navbar/controller/bottom_navabr_cotroller.dart';
import 'package:ZipBee/features/user/home/screen/home_screen.dart';
import 'package:ZipBee/features/user/order/screen/order_screen.dart';
import 'package:ZipBee/features/user/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> _screens = [HomeScreen(), OrderScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: _screens[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.backgroungColor,
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
                backgroundColor: AppColors.backgroungColor,
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
                label: 'Orders',
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
    );
  }
}
