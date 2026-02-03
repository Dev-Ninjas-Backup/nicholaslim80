import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/custom_icon_text_button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:ZipBee/features/user/finding_raider/widget/raider_info.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/stacked_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class RaiderDetails extends StatefulWidget {
  const RaiderDetails({super.key});

  @override
  State<RaiderDetails> createState() => _RaiderDetailsState();
}

class _RaiderDetailsState extends State<RaiderDetails> {
  late RiderController controller;
  late StackedOrderController orderController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<RiderController>();
    orderController = Get.find<StackedOrderController>();

    // Fetch order data when this screen opens
    _fetchOrderDataOnInit();
  }

  void _fetchOrderDataOnInit() {
    // Get order ID from StackedOrderController
    String rawId = orderController.orderNumber.value.replaceAll(RegExp(r'[^0-9]'), '');
    int? id = int.tryParse(rawId);

    if (id != null && id != 0) {
      controller.fetchOrderData(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
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
                          
                          // Display rider info from API
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
                                onPressed: () {},
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
                                  Text('Total',
                                      style: getTextStyle(fontSize: 12)),
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
                              Text(_formatDateTime(controller.orderCreatedAt.value)),
                            ],
                          ),

                          SizedBox(height: 24),
                          LocationRowWidget(
                            iconPath: IconPath.collectIcon,
                            title: controller.pickupName.value.isEmpty
                                ? 'Collected from'
                                : 'Collected from (${controller.pickupName.value})',
                            address: controller.pickupAddress.value,
                          ),
                          Icon(Icons.fiber_manual_record,
                              size: 10, color: Colors.grey),
                          Icon(Icons.fiber_manual_record,
                              size: 10, color: Colors.grey),
                          LocationRowWidget(
                            iconPath: IconPath.deliveredIcon,
                            title: controller.dropName.value.isEmpty
                                ? 'Deliver to'
                                : 'Deliver to (${controller.dropName.value})',
                            address: controller.dropAddress.value,
                          ),

                          SizedBox(height: 20),

                          Button(
                            buttonText: 'Share Ride Information',
                            backgroundColor:
                                AppColors.onboardingIndicatorActive,
                            textColor: Colors.black,
                            onPressed: () {
                              // ignore: deprecated_member_use
                              Share.share('Inviting friends.');
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

  // Build payment display based on payment type
  Widget _buildPaymentDisplay() {
    return Obx(
      () {
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  // Format datetime from ISO string
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