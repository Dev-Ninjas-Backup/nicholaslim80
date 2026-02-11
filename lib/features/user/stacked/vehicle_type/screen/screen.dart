import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import '../widget/vihicle_tab_page.dart';

class StackedVehicleSelectionPage extends StatelessWidget {
  const StackedVehicleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StackedVehicleController());

    final args = Get.arguments as Map<String, dynamic>?;

    int initialIndex = 0;

    if (args != null) {
      if (args['initialIndex'] != null) {
        initialIndex = args['initialIndex'];
      }

      if (args['initialDistanceKm'] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.totalDistanceKm.value =
              (args['initialDistanceKm'] as num).toDouble();

          debugPrint(
              'Initial distance: ${controller.totalDistanceKm.value}');
        });
      }
    }

    return DefaultTabController(
      length: 4,
      initialIndex: initialIndex, // 🔥 IMPORTANT
      child: Scaffold(
        backgroundColor: AppColors.backgroungColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Vehicle Type',
            style: getTextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: AppColors.backgroungColor,
              margin: const EdgeInsets.only(top: 5),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: [
                  Tab(
                    icon: Image.asset(
                      IconPath.bike2,
                      height: 60,
                      width: 70,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.car2,
                      height: 60,
                      width: 70,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.shipment,
                      height: 60,
                      width: 70,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.shopcar,
                      height: 60,
                      width: 70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            StackedVehicleTabPage(vehicleType: 'Courier'),
            StackedVehicleTabPage(vehicleType: 'Car'),
            StackedVehicleTabPage(vehicleType: 'Van'),
            StackedVehicleTabPage(vehicleType: 'Truck'),
          ],
        ),
      ),
    );
  }
}
