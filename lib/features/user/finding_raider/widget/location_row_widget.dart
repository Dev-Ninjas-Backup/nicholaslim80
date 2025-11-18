import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class LocationRowWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String address;

  const LocationRowWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 14, height: 14),
        SizedBox(width: 16),
        Expanded(
          child: _buildLocationCard(title: title, address: address),
        ),
      ],
    );
  }
}

Widget _buildLocationCard({required String title, required String address}) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          address,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
