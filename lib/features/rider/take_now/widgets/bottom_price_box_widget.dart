import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

class BottomPriceBox extends StatelessWidget {
  const BottomPriceBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Image.asset(IconPath.exparess, width: 24),
          SizedBox(width: 8),
          Text("8.9KM", style: TextStyle(fontWeight: FontWeight.w600)),
          Spacer(),
          Container(width: 1, height: 24, color: Colors.grey.shade400),
          Spacer(),
          Text(
            "\$15.00 + \$10.50",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
