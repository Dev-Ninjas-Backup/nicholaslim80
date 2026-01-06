import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/kamrul_express/controller/kamrul_express_controller.dart';
import 'package:ZipBee/features/kamrul_express/widget/collect_time_widget.dart';
import 'package:ZipBee/features/kamrul_express/widget/location_card.dart';
import 'package:ZipBee/features/kamrul_express/widget/total_section_widget.dart';
import 'package:ZipBee/features/kamrul_express/widget/trip_selector_widget.dart';
import 'package:ZipBee/features/kamrul_express/widget/vehicle_type_widget.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class KamrulExpressScreen extends StatelessWidget {
  final controller = Get.put(KamrulExpressController());

  KamrulExpressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Express Delivery',
              style: getTextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.black87, size: 20),
              onPressed: () {
                Get.toNamed(AppRoutes.getexpressFaq());
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Location",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 10),
            tripSelector(),

            locationCard(),
            SizedBox(height: 25),

            collectTime(),
            SizedBox(height: 30),

            vehicleSelector(),
            SizedBox(height: 40),

            totalSection(),
          ],
        ),
      ),
    );
  }
}
