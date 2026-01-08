import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../orders/completed_order_details/proof_of_delivery_screen/proof_of_delivery_screen.dart';
import '../../../model/order_model.dart';

class CompletedOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const CompletedOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.primaryButtonColor,
              width: double.infinity,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Order #${order.orderId} is completed",
                      style: getTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rider / Sender Details
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "assets/images/profileImage.jpg",
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.senderName,
                                style: getTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Vehicle type: ${order.vehicleType}",
                                style: getTextStyle(fontSize: 13),
                              ),
                              Text(
                                "Order ${order.orderId}",
                                style: getTextStyle(fontSize: 13),
                              ),
                              Text(
                                "Est. Delivery time: ${order.date}",
                                style: getTextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Stops
                    _buildStop(
                      icon: IconPath.locationBlue,
                      color: Colors.blue,
                      title: "Collected from (${order.senderName})",
                      address: order.pickupAddress,
                      date: order.date,
                    ),
                    _buildStop(
                      icon: IconPath.locationRed,
                      color: Colors.red,
                      title: "Delivered to",
                      address: order.dropOffAddress,
                      date: order.date,
                    ),

                    SizedBox(height: 16),
                    Text(
                      "Total: S\$${order.total.toStringAsFixed(2)}",
                      style: getTextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Get.to(() => ProofOfDeliveryScreen()),
                      child: Text(
                        "View Proof of Delivery",
                        style: getTextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStop({
    required String icon,
    required Color color,
    required String title,
    required String address,
    required String date,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 28, width: 18),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: getTextStyle(fontWeight: FontWeight.w600)),
                Text(address, style: getTextStyle(fontSize: 13)),
                Text(
                  date,
                  style: getTextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
