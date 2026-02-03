import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RaiderInfoWidget extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();
  final StackedOrderController orderController =
      Get.find<StackedOrderController>();

  RaiderInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if assign_rider data is available
      if (controller.assignRiderData.value == null) {
        return Center(child: Text('No rider information available'));
      }

      final assignRider = controller.assignRiderData.value;
      final registration =
          assignRider['registrations'] != null &&
              (assignRider['registrations'] as List).isNotEmpty
          ? assignRider['registrations'][0]
          : null;

      final riderName = registration?['raider_name'] ?? 'Unknown';
      final vehicleType = assignRider['raider_status'] ?? 'ACTIVE';

      return Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: AssetImage(ImagePath.profileImage),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $riderName',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rank: ${assignRider['rank'] ?? 'BRONZE'}',
                  style: getTextStyle(fontSize: 13),
                ),
                Text(
                  'Orders: ${orderController.orderNumber.value}',
                  style: getTextStyle(fontSize: 13),
                ),
                Text(
                  'Status: ${vehicleType}',
                  style: getTextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
