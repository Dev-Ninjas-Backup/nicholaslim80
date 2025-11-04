import 'package:flutter/material.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/rider/rider_home/widgets/swipe_button_widget.dart';
import '../controller/rider_home_controller.dart';
import '../model/home_order_model.dart';

class RiderCardWidget extends StatelessWidget {
  final HomeOrderModel order;
  final int index;
  final RiderHomeController ctrl;

  const RiderCardWidget({
    super.key,
    required this.order,
    required this.index,
    required this.ctrl,
  });

  Color _getButtonColor(int type, String orderType) {
    // dynamic color based on type
    if (type == 1) return Colors.green; // accepted
    if (type == 2) return Colors.grey; // declined

    // default (pending): depends on order type
    switch (orderType.toLowerCase()) {
      case 'car':
        return Colors.blue.shade100;
      case 'taxi':
        return Colors.yellow.shade200;
      case 'courier':
        return Colors.orange.shade200;
      default:
        return AppColors.onboardingIndicatorActive;
    }
  }

  String _getSwipeButtonIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return IconPath.car;
      case 'taxi':
        return IconPath.taxi;
      case 'courier':
        return IconPath.bike;
      default:
        return IconPath.car;
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
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Top-left circle icon stays the same
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      IconPath.exparess, // <- unchanged
                      width: 24,
                      height: 24,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.type,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        order.code,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryFontColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.time,
                    style: getTextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Pickup & Delivery
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(IconPath.locationBlue, width: 18, height: 18),
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(IconPath.locationRed, width: 18, height: 18),
                ],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.pickup,
                      style: getTextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.delivery,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            'Summary the comments here',
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Swipe Button
          SwipeButtonWidget(
            leftText: 'LEFT TO DECLINE',
            rightText: 'TAKE NOW',
            onAccept: () => ctrl.acceptOrder(index),
            onDecline: () => ctrl.declineOrder(index),
            backgroundColor: _getButtonColor(order.colorType, order.type),
            height: 50,
            iconPath: _getSwipeButtonIcon(order.type),
          ),
        ],
      ),
    );
  }
}
