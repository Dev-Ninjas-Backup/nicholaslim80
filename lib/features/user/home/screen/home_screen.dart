import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';
import 'package:ZipBee/features/user/home/widgets/drawer.dart';
import 'package:ZipBee/features/user/home/widgets/small_horizontal_slider_widget.dart';
import 'package:ZipBee/features/user/home/widgets/vehicle_cards_widget.dart';
import 'package:ZipBee/features/user/wallet/loyalty_and_rewards/screen/loyalty_and_rewards_screen.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print("jsdhdff ${ctrl.availablePoints.value}");
    const padding = 16.0;
    final media = MediaQuery.of(context);
    final width = media.size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.checkAndShowPopup(context);
    });

    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroungColor,
        centerTitle: false,

        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.primaryFontColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),

        title: Obx(
          () => Text(
            ctrl.userName.value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryFontColor,
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppColors.primaryFontColor,
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.getUserNotification());
            },
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    IconPath.parcel,
                    color: Colors.blue,
                    height: 26,
                    width: 26,
                  ),
                  SizedBox(width: 6),

                  Obx(
                    () => Text(
                      ctrl.parcelStatusText,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: drawer(ctrl),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.myWalletUser),
                      child: borderedInfoCard(
                        title: 'Wallet Balance',
                        valueBuilder: () =>
                            '\$${ctrl.walletBalance.value.toStringAsFixed(2)}',
                        iconPath: IconPath.wallet,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(LoyaltyAndRewardsScreen()),
                      child: borderedInfoCard(
                        title: 'Available Points',
                        valueBuilder: () => '${ctrl.availablePoints.value}',
                        iconPath: IconPath.points,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            Text(
              'Service Options',
              style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => serviceCardCompact(
                      title: 'Express',
                      subtitle:
                          'Courier takes only your package and delivers instantly',
                      iconPath: IconPath.parcel,
                      selected: ctrl.deliveryType.value == 'express',
                      onTap: () {
                        ctrl.selectDeliveryType('express');
                      },
                    ),
                  ),
                ),

                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => serviceCardCompact(
                      title: 'Standard',
                      subtitle:
                          'Choose available time with flexible delivery charges',
                      iconPath: IconPath.select,
                      selected: ctrl.deliveryType.value == 'standard',
                      onTap: () {
                        ctrl.selectDeliveryType('standard');
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),

            Obx(
              () => serviceCardStacked(
                title: 'Stacked',
                subtitle:
                    'Courier takes all bundle packages and delivers together',
                iconPath: IconPath.stacked,
                selected: ctrl.deliveryType.value == 'stacked',
                onTap: () {
                  ctrl.selectDeliveryType('stacked');
                },
              ),
            ),

            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Vehicles',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            VehicleCards(ctrl: ctrl),

            SizedBox(height: 30),
            SmallHorizontalSlider(width: width),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget borderedInfoCard({
    required String title,
    required String Function() valueBuilder,
    IconData? icon,
    String? iconPath,
    Color? iconBgColor,
    double iconSize = 20,
  }) {

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroungColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.subtitleFontColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor ?? Colors.white,
              shape: BoxShape.circle,
            ),
            child: iconPath != null
                ? Image.asset(iconPath, height: iconSize, width: iconSize)
                : Icon(icon, size: iconSize, color: Colors.white),
          ),

          SizedBox(height: 10),
          Text(
            title,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryFontColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            valueBuilder(),
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget serviceCardCompact({
    required String title,
    required String subtitle,
    IconData? icon,
    String? iconPath,
    required bool selected,
    required VoidCallback onTap,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              // ignore: deprecated_member_use
              ? AppColors.primaryButtonColor.withOpacity(0.15)
              : AppColors.onboardingIndicatorActive,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primaryButtonColor
                // ignore: deprecated_member_use
                : AppColors.subtitleFontColor.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconPath != null)
              Image.asset(iconPath, height: iconSize, width: iconSize)
            else if (icon != null)
              SizedBox(height: 8),
            Text(
              title,
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Text(
              subtitle,
              style: getTextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCardStacked({
    required String title,
    required String subtitle,
    IconData? icon,
    String? iconPath,
    required bool selected,
    required VoidCallback onTap,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              // ignore: deprecated_member_use
              ? AppColors.primaryButtonColor.withOpacity(0.15)
              : AppColors.onboardingIndicatorActive,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primaryButtonColor
                : AppColors.onboardingIndicatorActive,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconPath != null)
              Image.asset(iconPath, height: iconSize, width: iconSize)
            else if (icon != null)
              Icon(icon, size: iconSize),

            SizedBox(height: 12),

            Text(
              title,
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              subtitle,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryFontColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
