import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:ZipBee/features/user/stacked/widget/pic_date_time.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';

import '../stacked_controller/stacked_controller.dart';
import '../vehicle_type/controller/controller.dart';
import '../vehicle_type/screen/screen.dart';
import '../widget/collect_time_widget.dart';
import '../widget/select_location_widget.dart';
import '../widget/stack_order_review_button_widget.dart';
import '../stacked_controller/update_details_controller.dart';
import '../widget/vehicle_type_widget.dart';

class StackedScreen extends StatelessWidget {
  final StackedLocationController controller = Get.put(
    StackedLocationController(),
  );
  final vehicleController = Get.put(StackedVehicleController());
  final StackedOrderController orderController = Get.put(StackedOrderController());

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
        title: Builder(builder: (context) {
          final args = Get.arguments as Map<String, dynamic>?;
          final orderArg = args != null ? args['order'] as Map<String, dynamic>? : null;

          // If navigation included a prefill vehicle or deliveryType, apply them
          if (args != null && args.containsKey('prefillVehicle')) {
            try {
              final prefill = args['prefillVehicle'];
              if (prefill != null) {
                // set into vehicle controller directly
                try {
                  vehicleController.selectedVehicle.value = prefill as dynamic;
                  debugPrint('Prefilled vehicle set on StackedScreen');
                } catch (_) {
                  debugPrint('Prefill vehicle could not be applied');
                }
              }
            } catch (_) {}

            if (args['deliveryType'] != null) {
              try {
                final homeCtrl = Get.find<HomeController>();
                homeCtrl.selectDeliveryType((args['deliveryType'] as String).toLowerCase());
                debugPrint('Prefilled delivery type set to ${args['deliveryType']}');
              } catch (_) {}
            }
          }

          // Sync order info into controller if available
          if (orderArg != null) {
            try {
              final oc = Get.find<StackedOrderController>();
              oc.lastOrderId = orderArg['id'] as int?;
              oc.totalAmount.value = double.tryParse(orderArg['total_cost']?.toString() ?? '') ?? oc.totalAmount.value;
            } catch (_) {}

            // Apply route_type and collect_time to controllers
            try {
              final loc = Get.find<StackedLocationController>();
              if (orderArg['route_type'] != null) {
                loc.isRoundTrip.value = (orderArg['route_type'] == 'ROUND');
              }
              if (orderArg['collect_time'] != null) {
                final ct = orderArg['collect_time'];
                if (ct == 'ASAP') {
                  loc.isNowSelected.value = true;
                } else if (ct == 'SCHEDULED') {
                  loc.isNowSelected.value = false;
                  // set scheduled time if present
                  if (orderArg['scheduled_time'] != null) {
                    try {
                      final sched = Get.find<StackedScheduleController>();
                      sched.setNow(false);
                      final parsed = DateTime.parse(orderArg['scheduled_time']);
                      sched.setDateTime(parsed.toLocal());
                    } catch (_) {}
                  }
                }
              }
            } catch (_) {}

            // Set selected vehicle by id if provided
            try {
              final vctrl = Get.find<StackedVehicleController>();
              final vidRaw = orderArg['vehicle_type_id'];
              final vid = vidRaw is int ? vidRaw : int.tryParse(vidRaw?.toString() ?? '');
              if (vid != null) {
                final all = <dynamic>[]..addAll(vctrl.t1)..addAll(vctrl.t2)..addAll(vctrl.t3)..addAll(vctrl.t4);
                dynamic found;
                try {
                  found = all.firstWhere((v) => v.id == vid);
                } catch (_) {
                  found = null;
                }
                if (found != null) vctrl.selectedVehicle.value = found as dynamic;
              }
            } catch (_) {}
          }

          // Title comes from delivery_type if provided (as requested)
          final titleText = orderArg != null && orderArg['delivery_type'] != null
              ? '${(orderArg['delivery_type'] as String).toLowerCase().capitalize}'
              : 'Stacked';

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText,
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
                  final t = titleText.toLowerCase();
                  if (t == 'express') {
                    Get.toNamed(AppRoutes.getexpressFaq());
                  } else if (t == 'standard') {
                    Get.toNamed(AppRoutes.getstandardFAQ());
                  } else {
                    Get.toNamed(AppRoutes.getrstackedFAQScreen());
                  }
                },
              ),
            ],
          );
        }),
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
                        onTap: () async {
                          controller.selectNow();

                          // Ensure schedule controller set to Now as well
                          try {
                            final sched = Get.find<StackedScheduleController>();
                            sched.setNow(true);
                          } catch (_) {}

                          try {
                            final upd = Get.put(UpdateDetailsController());
                            final oc = Get.find<StackedOrderController>();
                            if (oc.lastOrderId != null) {
                              final ok = await upd.patchCollectTime(oc.lastOrderId!, 'ASAP');
                              if (ok) debugPrint('Collect time switched to ASAP for order ${oc.lastOrderId}');
                            }
                          } catch (e) {
                            debugPrint('patchCollectTime ASAP error: $e');
                          }
                        },
                      ),
                      SizedBox(width: 16),
                      StackedCollectTimeOption(
                        title: "Schedule",
                        subtitle: "Pick Date and Time",
                        selected: !controller.isNowSelected.value,
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          controller.selectSchedule();

                          // Open the date-time dialog and await selected datetime
                          final selected = await showDialog<DateTime?>(
                            context: context,
                            builder: (_) => StackedPickDateTimeDialog(),
                          );

                          if (selected != null) {
                            // Save selected time into schedule controller
                            try {
                              final sched = Get.find<StackedScheduleController>();
                              sched.setDateTime(selected.toLocal());
                              sched.setNow(false);
                            } catch (_) {}

                            // call API to update collect time to scheduled
                            try {
                              final upd = Get.put(UpdateDetailsController());
                              final oc = Get.find<StackedOrderController>();
                              if (oc.lastOrderId != null) {
                                await upd.patchCollectTime(
                                  oc.lastOrderId!,
                                  'SCHEDULED',
                                  scheduledTime: selected.toUtc().toIso8601String(),
                                );
                              }
                            } catch (_) {}
                          }
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
                      // Pass placeholder initial distance = 2.0 km. Replace with routing-based distance later.
                      Get.to(() => StackedVehicleSelectionPage(), arguments: {'initialDistanceKm': 2.0});
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

              ),
            ],
          ),
        ),
      ),
    );
  }
}
