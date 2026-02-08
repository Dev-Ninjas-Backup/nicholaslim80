import 'package:flutter/material.dart';
import '../../../../../../core/common/styles/global_text_style.dart';

class OrderStopsList extends StatelessWidget {
  final String senderName;
  final String pickupAddress;
  final String recipientName;
  final String dropOffAddress;

  const OrderStopsList({
    super.key,
    required this.senderName,
    required this.pickupAddress,
    required this.recipientName,
    required this.dropOffAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStopItem(isPickup: true, title: "Collected from (Sender: $senderName)", address: pickupAddress),
        _buildStopItem(isPickup: false, title: "Deliver to (Recipient: $recipientName)", address: dropOffAddress),
      ],
    );
  }

  Widget _buildStopItem({required bool isPickup, required String title, required String address}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20, width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isPickup ? Colors.blue : Colors.red, width: 2),
              ),
              child: Center(child: Container(height: 8, width: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: isPickup ? Colors.blue : Colors.red))),
            ),
            if (isPickup) Container(height: 30, width: 2, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              Text(address, style: getTextStyle(fontSize: 13)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}