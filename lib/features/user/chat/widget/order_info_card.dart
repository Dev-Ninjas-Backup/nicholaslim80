import 'package:flutter/material.dart';

class OrderInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFFFFFBE6), // Light yellowish-white
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order #1288 Pick-up Date & Time, 24 Aug 25, 10.10am",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          SizedBox(height: 8),
          Text(
            "From Athena Lin → Joseph Low",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          SizedBox(height: 4),
          Text(
            "Vehicle type: Car, Total: S\$10.00",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ],
      ),
    );
  }
}