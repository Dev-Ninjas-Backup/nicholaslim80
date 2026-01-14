import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/custom_icon_text_button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';

class RaiderDetails extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  RaiderDetails({super.key});

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
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dragHandle(),
                          const SizedBox(height: 24),

                          /// RIDER INFO
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 36,
                                backgroundImage:
                                    AssetImage(ImagePath.profileImage),
                              ),
                              const SizedBox(width: 11),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${controller.riderName.value}',
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// MESSAGE / CALL
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconTextButton(
                                text: 'Message',
                                iconPath: IconPath.message,
                                borderColor: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {},
                              ),
                              CustomIconTextButton(
                                text: 'Call',
                                iconPath: IconPath.call,
                                borderColor: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(),

                          /// TOTAL
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total',
                                      style: getTextStyle(fontSize: 12)),
                                  Text('/\$24.00',
                                      style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(IconPath.visa),
                                  const SizedBox(width: 8),
                                  const Text("***456",
                                      style: TextStyle(
                                          fontSize: 20,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
                            ],
                          ),

                          const Divider(),
                          const SizedBox(height: 10),

                          /// DATE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Date & Time'),
                              Text(controller.dateTime.value),
                            ],
                          ),

                          const SizedBox(height: 24),

                          /// ✅ LOCATION (API DRIVEN)
                          LocationRowWidget(
                            iconPath: IconPath.collectIcon,
                            title:
                                'Collected from (${controller.pickupName.value})',
                            address: controller.pickupAddress.value,
                          ),
                          const Icon(Icons.fiber_manual_record,
                              size: 10, color: Colors.grey),
                          const Icon(Icons.fiber_manual_record,
                              size: 10, color: Colors.grey),
                          LocationRowWidget(
                            iconPath: IconPath.deliveredIcon,
                            title:
                                'Deliver to (${controller.dropName.value})',
                            address: controller.dropAddress.value,
                          ),

                          const SizedBox(height: 20),

                          Button(
                            buttonText: 'Share Ride Information',
                            backgroundColor:
                                AppColors.onboardingIndicatorActive,
                            textColor: Colors.black,
                            onPressed: () {
                              Share.share('Inviting friends.');
                            },
                          ),
                        ],
                      ),
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
}
