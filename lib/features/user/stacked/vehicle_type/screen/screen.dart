import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

import '../widget/vihicle_tab_page.dart';

class StackedVehicleSelectionPage extends StatelessWidget {
  const StackedVehicleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: AppColors.backgroungColor,
              margin: EdgeInsets.only(top: 5),
              child: TabBar(
                isScrollable: false, // evenly spaced
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.car2,
                      height: 60,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.shipment,
                      height: 60,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      IconPath.shopcar,
                      height: 60,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
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

