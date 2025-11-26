import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/order_express_delivery/controller/order_controller.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/order_express_delivery/screen/order_alertdialog_screen.dart';

import 'package:nicholaslim80/routes/app_routes.dart';

import '../../express_delivery_1/widget/pick_date_time_dialog.dart';
import '../stacked_controller/stacked_controller.dart';
import '../vehicle_type/controller/controller.dart';
import '../vehicle_type/screen/screen.dart';
import '../widget/collect_time_widget.dart';
import '../widget/select_location_widget.dart';
import '../widget/stack_order_review_button_widget.dart';
import '../widget/vehicle_type_widget.dart';

class StackedScreen extends StatelessWidget {
  final StackedLocationController controller = Get.put(
    StackedLocationController(),
  );
  final vehicleController = Get.put(StackedVehicleController());
  final OrderController orderController = Get.put(OrderController());

  StackedScreen({super.key});

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
              'Stacked',
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
                Get.toNamed(AppRoutes.getrstackedFAQScreen());
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
              StackedSelectLocationWidget(controller: controller),
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
                      StackedCollectTimeOption(
                        title: "Now",
                        selected: controller.isNowSelected.value,
                        onTap: controller.selectNow,
                      ),
                      SizedBox(width: 16),
                      StackedCollectTimeOption(
                        title: "Schedule",
                        subtitle: "Pick Date and Time",
                        selected: !controller.isNowSelected.value,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          controller.selectSchedule();

                          // Open the date-time dialog
                          showDialog(
                            context: context,
                            builder: (_) => PickDateTimeDialog(),
                          );
                        },
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
                      Get.to(() => StackedVehicleSelectionPage());
                    },
                    icon: Icon(Icons.info_outline),
                    color: Colors.black87,
                    iconSize: 20,
                  ),
                ],
              ),
              SizedBox(height: 4),
              StackedVehicleTypeWidget(controller: controller),

              SizedBox(height: 24),
              StackedOrderReviewButtonStatic(
                onPressed: () {
                  showOrderConfirmationDialog(orderController);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
