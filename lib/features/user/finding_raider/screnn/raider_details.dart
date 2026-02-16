import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:ZipBee/features/user/chat/screen/chat_screen.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/custom_icon_text_button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/order_location_info_widget.dart';
import 'package:ZipBee/features/user/finding_raider/widget/raider_info.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class RaiderDetails extends StatelessWidget {
  RaiderDetails({super.key});

  final RiderController controller = Get.find<RiderController>();
  final StackedOrderController orderController =
      Get.find<StackedOrderController>();

  void _fetchOrderDataOnInit() {
    String rawId = orderController.orderNumber.value.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    int? id = int.tryParse(rawId);

    if (id != null && id != 0) {
      controller.fetchOrderData(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This will run when widget builds
    _fetchOrderDataOnInit();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.offAll(() => BottomNavbarScreen());
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(IconPath.colorFullArrow, width: 24),
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(child: GoogleMapWidget()),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dragHandle(),
                          SizedBox(height: 24),
                          RaiderInfoWidget(),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconTextButton(
                                text: 'Message',
                                iconPath: IconPath.message,
                                borderColor: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () => Get.to(
                                  ChatScreen(
                                    receiverId:
                                        (controller
                                                    .assignRiderData
                                                    .value?['userId'] ??
                                                0)
                                            .toString(),
                                    senderName:
                                        controller
                                            .assignRiderData
                                            .value?['name'] ??
                                        '',
                                    orderId: controller.orderId.value
                                        .toString(),
                                    totalCost: controller.totalCost.value
                                        .toStringAsFixed(2),
                                    vehicleType: controller.vehicleType.value,
                                  ),
                                ),
                              ),

                              CustomIconTextButton(
                                text: 'Call',
                                iconPath: IconPath.call,
                                borderColor: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total',
                                    style: getTextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    '\$${controller.totalCost.value.toStringAsFixed(2)}',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              _buildPaymentDisplay(),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date & Time'),
                              Text(
                                _formatDateTime(
                                  controller.orderCreatedAt.value,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          OrderLocationInfoWidget(
                            pickupStops: controller.pickupStops,
                            dropStops: controller.dropStops,
                          ),
                          SizedBox(height: 20),
                          Button(
                            buttonText: 'Share Ride Information',
                            backgroundColor:
                                AppColors.onboardingIndicatorActive,
                            textColor: Colors.black,
                            onPressed: () {
                              final assignRider =
                                  controller.assignRiderData.value;
                              final registration =
                                  (assignRider != null &&
                                      assignRider['registrations'] != null &&
                                      (assignRider['registrations'] as List)
                                          .isNotEmpty)
                                  ? assignRider['registrations'][0]
                                  : null;

                              final riderName =
                                  registration?['raider_name'] ??
                                  'Not Assigned';
                              final orderId = orderController.orderNumber.value;
                              final pickup =
                                  controller.pickupAddress.value.isEmpty
                                  ? 'N/A'
                                  : controller.pickupAddress.value;
                              final destination =
                                  controller.dropAddress.value.isEmpty
                                  ? 'N/A'
                                  : controller.dropAddress.value;
                              final totalCost = controller.totalCost.value
                                  .toStringAsFixed(2);

                              String paymentMethod = 'Online Payment';
                              if (controller.paymentType.value == 'COD')
                                paymentMethod = 'Cash on Delivery';
                              if (controller.paymentType.value == 'WALLET')
                                paymentMethod = 'Wallet';

                              final String shareMessage =
                                  '''
🐝 *ZipBee | Ride Details*
--------------------------------------
🆔 *Order ID:* $orderId
👤 *Assign Rider ID:* ${controller.assignRiderData.value?['id'] ?? 'N/A'}
👤 *Rider:* $riderName
💰 *Total Fare:* \$$totalCost ($paymentMethod)

📍 *Pickup:* $pickup

🏁 *Drop-off:* $destination

📅 *Date & Time:* ${_formatDateTime(controller.orderCreatedAt.value)}
--------------------------------------
Track your ride live on the ZipBee app.
*Safe travels!*
''';

                              Share.share(shareMessage);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dragHandle() => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _buildPaymentDisplay() {
    return Obx(() {
      final payType = controller.paymentType.value;

      if (payType == 'ONLINE_PAY') {
        return Row(
          children: [
            Image.asset(IconPath.visa, height: 24),
            SizedBox(width: 8),
          ],
        );
      } else if (payType == 'WALLET') {
        return Row(
          children: [
            Image.asset(IconPath.wallet, height: 24),
            SizedBox(width: 8),
            Text(
              'Wallet',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        );
      } else if (payType == 'COD') {
        return Row(
          children: [
            Icon(Icons.money, size: 24, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Cash',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        );
      }

      return SizedBox.shrink();
    });
  }

  String _formatDateTime(String isoString) {
    if (isoString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
