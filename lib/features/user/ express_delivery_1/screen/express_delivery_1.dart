import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/controller/express_controller_1.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/screen/order_controller_screen.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/collect_time_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/order_review_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/select_location_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/widget/vehicle_type_widget.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/controller/vehicle_Controller.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/screen/veichale_secation_page.dart';

import 'package:nicholaslim80/routes/app_routes.dart';

class ExpressDelivery1 extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());
  final vehicleController = Get.put(VehicleController());
  final OrderControllerScreen orderController = Get.put(
    OrderControllerScreen(),
  );

  ExpressDelivery1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
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
            SizedBox(width: 4.0),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Select Location',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SelectLocationWidget(controller: controller),
              SizedBox(height: 24),
              Text(
                'Collect time',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CollectTimeOption(
                        title: "Now",
                        selected: controller.isNowSelected.value,
                        onTap: controller.selectNow,
                      ),
                      SizedBox(width: 16),
                      CollectTimeOption(
                        title: "Schedule",
                        subtitle: "Pick Date and Time",
                        selected: !controller.isNowSelected.value,
                        onTap: controller.selectSchedule,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Vehicle type',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => VehicleSelectionPage());
                    },
                    icon: Icon(Icons.info_outline),
                    color: Colors.black87,
                    iconSize: 20,
                  ),
                ],
              ),
              SizedBox(height: 4),
              VehicleTypeWidget(controller: controller),

              SizedBox(height: 24),
              OrderReviewWidget(
                total: 15,
                vehicleController: vehicleController,
                calculationHistory: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
