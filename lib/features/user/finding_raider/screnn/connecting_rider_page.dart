import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/finding_raider/controller/rider_controller.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/button.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/location_row_widget.dart';

class ConnectingRiderPage extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();

  ConnectingRiderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset(ImagePath.map, fit: BoxFit.cover)),

          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Connecting to rider...',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 20),
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 69,
                                      height: 6,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller.firstActive.value
                                            ? Colors.amber
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    Container(
                                      width: 69,
                                      height: 6,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller.secondActive.value
                                            ? Colors.amber
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        Row(
                          spacing: 11,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              radius: 36,

                              backgroundImage: AssetImage(
                                ImagePath.profileImage,
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${controller.riderName.value}',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Vehicle type: ${controller.vehicleType.value}',
                                  style: getTextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Order ${controller.orderNumber.value}',
                                  style: getTextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Arriving in ${controller.arrivalTime.value}',
                                  style: getTextStyle(fontSize: 13),
                                ),
                              ],
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
                                  style: getTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '/\$24.00',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(IconPath.visa),
                                SizedBox(width: 8),
                                Text(
                                  "***456",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date & Time'),
                            Text(controller.dateTime.value),
                          ],
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LocationRowWidget(
                                iconPath: IconPath.collectIcon,
                                title: 'Collected from (Sender: Athena Lin)',
                                address: 'Deliver to (Recipent: Joseph Low)',
                              ),

                              Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.grey,
                              ),
                              Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Colors.grey,
                              ),
                              LocationRowWidget(
                                iconPath: IconPath.deliveredIcon,
                                title: 'Deliver to (Recipent: Joseph Low)',
                                address: 'Blk 222 Sengkang Ave 2, S530222',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        Button(
                          buttonText: 'Share Ride Information',
                          textColor: Colors.black,
                          backgroundColor: Colors.amber,
                        ),
                        SizedBox(height: 16),
                      ],
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
}
