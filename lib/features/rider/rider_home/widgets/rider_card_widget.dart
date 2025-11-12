import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/rider/rider_home/widgets/swipe_button_widget.dart';
import 'package:nicholaslim80/features/rider/take_now/screen/take_now_screen.dart';
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

  // dynamic color based on order type
  Color getButtonColor(int type, String orderType) {
    if (type == 1) return Colors.blue; // accepted
    if (type == 2) return Colors.grey; // declined

    switch (orderType.toLowerCase()) {
      case 'car':
        return Colors.blue.shade100;
      case 'taxi':
        return AppColors.onboardingIndicatorActive;
      case 'courier':
        return AppColors.onboardingIndicatorActive;
      default:
        return AppColors.onboardingIndicatorActive;
    }
  }

  // only the swipe button icon changes dynamically
  String getSwipeButtonIcon(String type) {
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
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Top-left circle icon stays the same
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      IconPath.exparess, // unchanged
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 12),
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
                  SizedBox(height: 4),
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

          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 8),

          // Pickup & Delivery
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(IconPath.locationBlue, width: 18, height: 18),
                  SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 4),
                  Image.asset(IconPath.locationRed, width: 18, height: 18),
                ],
              ),
              SizedBox(width: 6),
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
                    SizedBox(height: 12),
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

          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 8),

          Text(
            'Summary the comments here',
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          SwipeButtonWidget(
            leftText: 'LEFT TO DECLINE',
            rightText: 'TAKE NOW',
            onAccept: () {
              Get.to(() => TakeNowScreen());
            },
            onDecline: () {
              ctrl.declineOrder(index);
            },
            backgroundColor: getButtonColor(order.colorType, order.type),
            height: 50,
            iconPath: getSwipeButtonIcon(order.type),
          ),
        ],
      ),
    );
  }
}
