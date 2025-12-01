import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/features/user/Sechedule_veycale_type/screen/veycale_main.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/controller/express_controller_1.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/order_express_delivery/controller/order_controller.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/order_express_delivery/screen/order_alertdialog_screen.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/widget/collect_time_widget.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/widget/order_review_widget.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/widget/pick_date_time_dialog.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/widget/vehicle_type_widget.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/controller/vehicle_Controller.dart';
import 'package:nicholaslim80/features/user/schedule_round_delivery/widget/round4button.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class ScheduleRoundDelivery extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());
  final VehicleController vehicleController = Get.find<VehicleController>();

  ScheduleRoundDelivery({super.key});

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.backgroungColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              hideKeyboard();
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
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.black87, size: 20),
                onPressed: () {
                  hideKeyboard();
                  Get.toNamed(AppRoutes.getexpressFaq());
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Location Section
                Text(
                  'Select Location',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Round4(controller: controller),

                SizedBox(height: 24),

                // 🔹 Collect Time Section
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
                      children: [
                        CollectTimeOption(
                          title: "Now",
                          selected: controller.isNowSelected.value,
                          onTap: () {
                            hideKeyboard();
                            controller.selectNow();
                          },
                        ),
                        SizedBox(width: 16),
                        CollectTimeOption(
                          title: "Schedule",
                          subtitle: "Pick Date and Time",
                          selected: !controller.isNowSelected.value,
                          onTap: () {
                            hideKeyboard();
                            controller.selectSchedule();

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

                // 🔹 Vehicle Type Section
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
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        hideKeyboard();
                        Get.to(() => SecheduleVehicleSelectionPage());
                      },
                    ),
                  ],
                ),

                SizedBox(height: 4),
                VehicleTypeWidget(controller: controller),

                SizedBox(height: 24),

                // 🔹 Order Review Section
                OrderReviewWidget(
                  vehicleController: vehicleController,
                  total: 123.45,
                  calculationHistory: vehicleController.calculationHistory,
                  onReviewOrderPressed: () {
                    // Find your controller or create it if not already
                    final orderController = Get.put(OrderController());

                    // Set the total amount from the review
                    orderController.totalAmount = 123.45;

                    // Show the confirmation dialog
                    showOrderConfirmationDialog(orderController);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
