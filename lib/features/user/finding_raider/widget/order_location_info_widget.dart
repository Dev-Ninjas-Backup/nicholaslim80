import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';

class OrderLocationInfoWidget extends StatelessWidget {
  final RxList<Map<String, String>> pickupStops;
  final RxList<Map<String, String>> dropStops;

  const OrderLocationInfoWidget({
    super.key,
    required this.pickupStops,
    required this.dropStops,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Pickup List ---
          Obx(() => ListView.builder(
                padding: EdgeInsets.zero, // এখানে জিরো প্যাডিং দিলে উপরের স্পেস চলে যাবে
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pickupStops.length,
                itemBuilder: (context, index) {
                  return LocationRowWidget(
                    iconPath: IconPath.collectIcon,
                    title: 'Collected from (Sender: ${pickupStops[index]['name']})',
                    address: pickupStops[index]['address'] ?? '-',
                  );
                },
              )),

          SizedBox(height: 8),
          // Connecting Dots
          if (pickupStops.isNotEmpty && dropStops.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 2, bottom: 2),
              child: Icon(Icons.more_vert, size: 20, color: Colors.grey),
            ),
          SizedBox(height: 8),

          // --- Drop List ---
          Obx(() => ListView.builder(
                padding: EdgeInsets.zero, // এখানেও জিরো প্যাডিং ব্যবহার করুন
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dropStops.length,
                itemBuilder: (context, index) {
                  return LocationRowWidget(
                    iconPath: IconPath.deliveredIcon,
                    title: 'Deliver to (Recipient: ${dropStops[index]['name']})',
                    address: dropStops[index]['address'] ?? '-',
                  );
                },
              )),
        ],
      ),
    );
  }
}