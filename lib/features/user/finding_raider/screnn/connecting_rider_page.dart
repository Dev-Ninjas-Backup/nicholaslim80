import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/raider_details.dart';
import 'package:ZipBee/features/user/finding_raider/utils/ride_share_message_builder.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/order_location_info_widget.dart';
import 'package:ZipBee/features/user/finding_raider/widget/payment_Info_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ConnectingRiderPage extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  final StackedOrderController orderController =
      Get.find<StackedOrderController>();

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
            Get.offAll(() => BottomNavbarScreen());
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
                                _formatDateTime(
                                  controller.orderCreatedAt.value,
                                ),
                                style: getTextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        Divider(height: 32),

                        // Collection and Delivery Locations
                        OrderLocationInfoWidget(
                          pickupStops: controller.pickupStops,
                          dropStops: controller.dropStops,
                          routeType: controller.routeType,
                        ),

                        SizedBox(height: 20),

                        Button(
                          buttonText: 'Share Ride Information',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                          onPressed: () {
                            final assignRider =
                                controller.assignRiderData.value;
                            final registration =
                                assignRider != null &&
                                    assignRider['registrations'] != null &&
                                    (assignRider['registrations'] as List)
                                        .isNotEmpty
                                ? assignRider['registrations'][0]
                                : null;

                            final orderId = orderController.orderNumber.value;
                            final riderId =
                                assignRider?['id']?.toString() ?? 'N/A';
                            final riderName =
                                registration?['raider_name']?.toString() ??
                                'Not Assigned';
                            final String
                            shareMessage = RideShareMessageBuilder.build(
                              orderId: orderId,
                              assignedRiderId: riderId,
                              riderName: riderName,
                              totalFare: controller.totalCost.value
                                  .toStringAsFixed(2),
                              paymentType:
                                  RideShareMessageBuilder.paymentMethodLabel(
                                    controller.paymentType.value,
                                  ),
                              pickupStops: controller.pickupStops,
                              dropStops: controller.dropStops,
                              routeType: controller.routeType.value,
                              scheduledDateTime:
                                  RideShareMessageBuilder.scheduledDateTimeLabel(
                                    scheduledTime:
                                        controller.scheduledTime.value,
                                    fallbackCreatedAt:
                                        controller.orderCreatedAt.value,
                                  ),
                              jobAcceptedTime:
                                  RideShareMessageBuilder.formatDateTime(
                                    controller.orderUpdatedAt.value,
                                  ),
                            );

                            SharePlus.instance.share(
                              ShareParams(text: shareMessage),
                            );
                          },
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
    controller.startPollingAssignRider(() {
      debugPrint('✅ Rider assigned, navigating to next screen');
      controller.stopPollingAssignRider();
      // Navigate to next screen after rider is assigned
      Get.to(() => RaiderDetails());
    });
  }

  String _formatDateTime(String isoString) =>
      RideShareMessageBuilder.formatDateTime(isoString);

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
