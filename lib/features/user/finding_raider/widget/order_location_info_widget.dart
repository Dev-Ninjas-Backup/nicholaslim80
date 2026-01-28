import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';

class OrderLocationInfoWidget extends StatelessWidget {
  final RxString pickupName;
  final RxString pickupAddress;
  final RxString dropName;
  final RxString dropAddress;

  const OrderLocationInfoWidget({
    super.key,
    required this.pickupName,
    required this.pickupAddress,
    required this.dropName,
    required this.dropAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collected from section
          Obx(
            () => LocationRowWidget(
              iconPath: IconPath.collectIcon,
              title: pickupName.value.isEmpty
                  ? 'Collected from'
                  : 'Collected from (Sender: ${pickupName.value})',
              address: pickupAddress.value.isEmpty ? '-' : pickupAddress.value,
            ),
          ),
          
          // Connecting dots
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
            child: Column(
              children: [
                Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
                SizedBox(height: 6),
                Icon(Icons.fiber_manual_record, size: 8, color: Colors.grey),
              ],
            ),
          ),

          // Deliver to section
          Obx(
            () => LocationRowWidget(
              iconPath: IconPath.deliveredIcon,
              title: dropName.value.isEmpty
                  ? 'Deliver to'
                  : 'Deliver to (Recipient: ${dropName.value})',
              address: dropAddress.value.isEmpty ? '-' : dropAddress.value,
            ),
          ),
        ],
      ),
    );
  }
}