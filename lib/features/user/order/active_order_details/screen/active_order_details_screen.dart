import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../../../core/utils/constants/image_path.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../model/order_model.dart';

class ActiveOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const ActiveOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              width: double.infinity,
              color: Color(0XFFFFCC00),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Order #${order.orderId} is pending for collection",
                      style: getTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Map Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: Text("Needs Google Map API", style: getTextStyle()),
            ),

            // Details
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroungColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RiderDetails(order: order),
                      SizedBox(height: 12),
                      MessageCallButtons(),
                      SizedBox(height: 8),
                      Reviews(),
                      SizedBox(height: 16),
                      PriceAndPayment(order: order),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Date & Time: ",
                            style: getTextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(order.date, style: getTextStyle()),
                        ],
                      ),
                      SizedBox(height: 20),
                      StopItem(
                        iconPath: IconPath.locationBlue,
                        title: "Collected from (${order.senderName})",
                        address: order.pickupAddress,
                      ),
                      StopItem(
                        iconPath: IconPath.locationRed,
                        title: "Deliver to",
                        address: order.dropOffAddress,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        label: 'Share Ride Information',
                        onPressed: () {},
                        color: AppColors.primaryButtonColor,
                        textColor: AppColors.fontColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiderDetails extends StatelessWidget {
  final OrderModel order;
  const RiderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(ImagePath.profileImage),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.senderName,
                style: getTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "Vehicle type: ${order.vehicleType}",
                style: getTextStyle(fontSize: 13),
              ),
              Text("Order ${order.orderId}", style: getTextStyle(fontSize: 13)),
              Text(
                "Scheduled to your pick-up time",
                style: getTextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageCallButtons extends StatelessWidget {
  const MessageCallButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: Image.asset(IconPath.message, height: 20, width: 20),
          label: Text(
            "Message",
            style: getTextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Image.asset(IconPath.call, height: 20, width: 20),
          label: Text("Call", style: getTextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 18),
        Icon(Icons.star, color: Colors.amber, size: 18),
        Icon(Icons.star, color: Colors.amber, size: 18),
        Icon(Icons.star, color: Colors.amber, size: 18),
        Icon(Icons.star, color: Colors.amber, size: 18),
        SizedBox(width: 6),
        Text("5/5", style: getTextStyle()),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            '(243 Reviews)',
            style: getTextStyle(color: Colors.lightBlue),
          ),
        ),
      ],
    );
  }
}

class PriceAndPayment extends StatelessWidget {
  final OrderModel order;
  const PriceAndPayment({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text("Total", style: getTextStyle(fontWeight: FontWeight.w600)),
            Text(
              "S\$${order.total.toStringAsFixed(2)}",
              style: getTextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(),
        Image.asset(IconPath.visa, height: 22, width: 24),
        SizedBox(width: 4),
        Text("****456", style: getTextStyle(fontSize: 13)),
      ],
    );
  }
}

class StopItem extends StatelessWidget {
  final String title;
  final String address;
  final String iconPath;

  const StopItem({
    super.key,
    required this.title,
    required this.address,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconPath.isNotEmpty
              ? Image.asset(iconPath, height: 18, width: 18)
              : Icon(Icons.location_on, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: getTextStyle(fontWeight: FontWeight.w600)),
                Text(address, style: getTextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
