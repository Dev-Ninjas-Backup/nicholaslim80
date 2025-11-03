// rider_card_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/rider/rider_home/widgets/swipe_button_widget.dart';
import '../controller/rider_home_controller.dart';

class RiderCardWidget extends StatelessWidget {
  final dynamic order;
  final int index;
  final RiderHomeController ctrl;

  const RiderCardWidget({
    super.key,
    required this.order,
    required this.index,
    required this.ctrl,
  });

  Color _getButtonColor(int type) {
    switch (type) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.yellow.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟦 Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.blue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.name, // আগে ছিল order.title
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            order.subtitle ?? '',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "3.1 Km  |  5 Mins",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // 🗺️ Route Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stop A',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Bishan',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(17.2 Km)',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // 🚗 Ride Request + Swipe Button
          const Text(
            'Ride Request',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwipeButtonWidget(
            leftText: 'LEFT TO DECLINE',
            rightText: 'TAKE NOW',
            onAccept: () {
              ctrl.acceptOrder(index);
              Get.snackbar(
                'Accepted',
                'You accepted ${order.name}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            onDecline: () {
              ctrl.declineOrder(index);
              Get.snackbar(
                'Declined',
                'You declined ${order.name}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            backgroundColor: _getButtonColor(order.colorType),
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${order.status}',
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
