import 'package:flutter/material.dart';

class OrderInfoCard extends StatelessWidget {
  final String orderId;

  final String fromName;
  final String toName;
  final String vehicleType;
  final double totalCost;

  const OrderInfoCard({
    super.key,
    required this.orderId,

    required this.fromName,
    required this.toName,
    required this.vehicleType,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFFBE6), // Light yellowish-white
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order #$orderId ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   "From $fromName → $toName",
          //   style: TextStyle(color: Colors.grey[700], fontSize: 13),
          // ),
          const SizedBox(height: 4),
          Text(
            "Vehicle type: $vehicleType, Total: S\$${totalCost.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
