import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../model/order_model.dart';

class PaymentAndTimeInfo extends StatelessWidget {
  final OrderModel order;
  const PaymentAndTimeInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String formattedTime = "N/A";
    try {
      if (order.scheduledTime.isNotEmpty) {
        formattedTime = DateFormat('dd MMM yy / hh:mm a').format(DateTime.parse(order.scheduledTime));
      }
    } catch (_) {}

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total", style: getTextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                Text("S\$${order.total.toStringAsFixed(2)}", style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            Row(
              children: [
                Image.asset(IconPath.visa, height: 24),
                const SizedBox(width: 8),
                Text("****456", style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date & Time", style: getTextStyle(color: Colors.grey, fontSize: 14)),
            Text(formattedTime, style: getTextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}