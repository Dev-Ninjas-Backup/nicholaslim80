import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/home/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    const padding = 16.0;
    final media = MediaQuery.of(context);
    final width = media.size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroungColor,
        centerTitle: false,

        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.primaryFontColor),
          onPressed: () {},
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
            onPressed: () {},
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
                  Icon(Icons.local_shipping, size: 16, color: Colors.blue),
                  SizedBox(width: 6),
                  Obx(
                    () => Text(
                      ctrl.parcelStatus.value,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            // Wallet & Points Cards
            Row(
              children: [
                Expanded(
                  child: borderedInfoCard(
                    title: 'Wallet Balance',
                    valueBuilder: () =>
                        '\$${ctrl.walletBalance.value.toStringAsFixed(2)}',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: borderedInfoCard(
                    title: 'Available Points',
                    valueBuilder: () => '${ctrl.availablePoints.value}',
                    icon: Icons.stars_outlined,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Service Options Title
            Text(
              'Service Options',
              style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 14),

            // Compact Service Cards
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => serviceCardCompact(
                      title: 'Express',
                      subtitle:
                          'Courier takes only your package and delivers instantly',
                      icon: Icons.flash_on,
                      selected: ctrl.selectedService.value == 'Express',
                      onTap: () => ctrl.selectService('Express'),
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
                      icon: Icons.check_circle_outline,
                      selected: ctrl.selectedService.value == 'Standard',
                      onTap: () => ctrl.selectService('Standard'),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            serviceCardStacked(
              title: 'Stacked',
              subtitle: 'Courier takes all bundle package and deliver together',
              icon: Icons.layers,
              onTap: () => ctrl.selectService('Stacked'),
            ),

            SizedBox(height: 22),

            // Available Vehicles Header
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
                TextButton(onPressed: () {}, child: Text('See all')),
              ],
            ),

            SizedBox(height: 8),

            // Vehicle Cards Horizontal List
            SizedBox(
              height: 315,
              child: Obx(() {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.vehicles.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final v = ctrl.vehicles[index];

                    return SizedBox(
                      width: 220,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.subtitleFontColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (v['image'] != null)
                              Container(
                                height: 130,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: v['image']),
                                ),
                              ),
                            SizedBox(height: 6),
                            Text(
                              v['title'],
                              style: getTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              v['subtitle'],
                              style: getTextStyle(
                                fontSize: 12,
                                color: AppColors.primaryFontColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    v['weight'],
                                    style: getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "\$${v['priceFrom']}",
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryButtonColor,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Select Vehicle',
                                  style: getTextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 30),

            // Small Horizontal Slider
            SizedBox(
              height: 125,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: width * 0.9,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryButtonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Buy GPS',
                                  style: getTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Invite friends and get 10 credit for every\n successful signup',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.subtitleFontColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------- Helper Widgets ----------
  Widget borderedInfoCard({
    required String title,
    required String Function() valueBuilder,
    required IconData icon,
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
          Icon(icon, size: 22, color: Colors.orange.shade800),
          SizedBox(height: 8),
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
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.onboardingIndicatorActive,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.orange.shade800),
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
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.onboardingIndicatorActive,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 28, color: Colors.orange.shade800),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryFontColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
