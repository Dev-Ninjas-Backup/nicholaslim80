import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/raider_details.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:ZipBee/features/user/finding_raider/widget/payment_Info_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectingRiderPage extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

    final StackedOrderController orderController = Get.find<StackedOrderController>();

  ConnectingRiderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Start polling when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPollingAndHandleRiderAssignment();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            controller.stopPollingAssignRider();
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(IconPath.colorFullArrow, width: 24),
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(child: GoogleMapWidget()),

          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        dragHandle(),
                        SizedBox(height: 16),

                        Text(
                          'Connecting to rider...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_stepBar(), _stepBar()],
                        ),

                        SizedBox(height: 16),
                        // Payment Information - Updated with API data
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ${orderController.orderNumber.value}',
                                    style: getTextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    '\$${controller.totalCost.value.toStringAsFixed(2)}',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              PaymentInfoWidget(),
                            ],
                          ),
                        ),

                        Divider(height: 32),

                        // Date & Time
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date & Time',
                                style: getTextStyle(fontSize: 12),
                              ),
                              Text(
                                _formatDateTime(controller.orderCreatedAt.value),
                                style: getTextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        Divider(height: 32),

                        // Collection and Delivery Locations 
                        Obx(
                          () => Column(
                            children: [
                              LocationRowWidget(
                                iconPath: IconPath.collectIcon,
                                title: controller.pickupName.value.isEmpty
                                    ? 'Collected from'
                                    : 'Collected from (${controller.pickupName.value})',
                                address: controller.pickupAddress.value,
                              ),
                              Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.grey,
                              ),
                              Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.grey,
                              ),
                              LocationRowWidget(
                                iconPath: IconPath.deliveredIcon,
                                title: controller.dropName.value.isEmpty
                                    ? 'Deliver to'
                                    : 'Deliver to (${controller.dropName.value})',
                                address: controller.dropAddress.value,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Button(
                          buttonText: 'Share Ride Information',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                          onPressed: () => Get.to(() => RaiderDetails()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Start polling and handle rider assignment
  void _startPollingAndHandleRiderAssignment() {
    controller.startPollingAssignRider(
      () {
        debugPrint('✅ Rider assigned, navigating to next screen');
        controller.stopPollingAssignRider();
        // Navigate to next screen after rider is assigned
        Get.to(() => RaiderDetails());
      },
    );
  }

  // Format datetime from ISO string
  String _formatDateTime(String isoString) {
    if (isoString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  Widget dragHandle() => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _stepBar() => Container(
    width: 69,
    height: 6,
    margin: EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
