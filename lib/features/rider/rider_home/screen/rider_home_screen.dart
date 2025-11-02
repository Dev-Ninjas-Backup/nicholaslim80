import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/rider/rider_home/controller/rider_home_controller.dart';
import 'package:slide_to_act/slide_to_act.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  Color _getButtonColor(int type) {
    switch (type) {
      case 0:
        return AppColors.primaryButtonColor;
      case 1:
        return Colors.blue.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Icon getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Icon(
          Icons.directions_car,
          color: Colors.blue.shade400,
          size: 22,
        );
      case 'taxi':
        return Icon(Icons.local_taxi, color: Colors.orange.shade400, size: 22);
      case 'courier':
        return Icon(
          Icons.local_shipping,
          color: Colors.green.shade400,
          size: 22,
        );
      default:
        return Icon(Icons.directions_car, color: Colors.grey, size: 22);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiderHomeController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Online",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            actions: [
              Obx(
                () => Switch(
                  value: ctrl.isOnline.value,
                  onChanged: ctrl.toggleOnline,
                  activeThumbColor: AppColors.onboardingIndicatorActive,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (ctrl.orders.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: ctrl.orders.length,
          itemBuilder: (context, index) {
            final order = ctrl.orders[index];
            final GlobalKey<SlideActionState> slideKey = GlobalKey();
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            getTypeIcon(order.type),
                            SizedBox(width: 6),
                            Text(
                              order.type,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          order.code,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Pickup & Delivery
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.circle, size: 10, color: Colors.green),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.pickup,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                order.delivery,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer, size: 18, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  order.time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.price,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Slide to act button
                    SlideAction(
                      key: slideKey,
                      height: 50,
                      borderRadius: 12,
                      text: order.buttonText,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      sliderButtonIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      outerColor: _getButtonColor(order.colorType),
                      innerColor: Colors.black,
                      onSubmit: () {
                        ctrl.updateOrderStatus(index);
                        slideKey.currentState?.reset();
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
