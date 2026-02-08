import 'package:flutter/material.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../model/order_model.dart';

class RiderDetailsCard extends StatelessWidget {
  final OrderModel order;
  const RiderDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: order.assignRiderImage.isNotEmpty
              ? NetworkImage(order.assignRiderImage) as ImageProvider
              : AssetImage(ImagePath.profileImage),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.assignRiderName,
                style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text("Vehicle type: ${order.vehicleType}", style: getTextStyle(fontSize: 14)),
              Text("Order ${order.orderId}", style: getTextStyle(fontSize: 14)),
              Text("Est. Delivery time: 30 min", style: getTextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}