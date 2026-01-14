// ignore_for_file: unused_local_variable

import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/raider_details.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectingRiderPage extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  ConnectingRiderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(IconPath.colorFullArrow, width: 24),
          ),
        ),
      ),
      body: Stack(
        children: [
          const SizedBox.expand(child: GoogleMapWidget()),

          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _dragHandle(),
                        const SizedBox(height: 16),

                        const Text(
                          'Connecting to rider...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_stepBar(), _stepBar()],
                        ),

                        const SizedBox(height: 16),

                        /// RIDER INFO
                        Row(
                          children: [
                             CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  AssetImage(ImagePath.profileImage),
                            ),
                            const SizedBox(width: 11),
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${controller.riderName.value}',
                                      style: getTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Vehicle type: ${controller.vehicleType.value}',
                                      style: getTextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      'Order ${controller.orderId.value}',
                                      style: getTextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      'Arriving in ${controller.arrivalTime.value}',
                                      style: getTextStyle(fontSize: 13),
                                    ),
                                  ],
                                )),
                          ],
                        ),

                        const Divider(height: 32),

                        /// LOCATION (API DRIVEN)
                        Obx(() => Column(
                              children: [
                                LocationRowWidget(
                                  iconPath: IconPath.collectIcon,
                                  title: controller.pickupName.value.isEmpty
                                      ? 'Collected from'
                                      : 'Collected from (${controller.pickupName.value})',
                                  address: controller.pickupAddress.value,
                                ),
                                const Icon(Icons.fiber_manual_record,
                                    size: 10, color: Colors.grey),
                                const Icon(Icons.fiber_manual_record,
                                    size: 10, color: Colors.grey),
                                LocationRowWidget(
                                  iconPath: IconPath.deliveredIcon,
                                  title: controller.dropName.value.isEmpty
                                      ? 'Deliver to'
                                      : 'Deliver to (${controller.dropName.value})',
                                  address: controller.dropAddress.value,
                                ),
                              ],
                            )),

                        const SizedBox(height: 20),

                        Button(
                          buttonText: 'Share Ride Information',
                          backgroundColor: Colors.amber,
                          textColor: Colors.black,
                          onPressed: () =>
                              Get.to(() => RaiderDetails()),
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

  Widget _dragHandle() => Center(
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(3),
        ),
      );
}
