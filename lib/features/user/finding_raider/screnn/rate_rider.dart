import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/finding_raider/controller/rider_controller.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/rate_rider_tip.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/button.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/review_rateing.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/two_side_icon_widget.dart';

class RateRider extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();
  RateRider({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset(ImagePath.map, fit: BoxFit.cover)),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.9,
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
                        SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // <-- avatar vertical center
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundImage: AssetImage(
                                ImagePath.profileImage,
                              ),
                            ),
                            SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // <-- column compact thakbe
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Name: ${controller.riderName.value}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Vehicle type: ${controller.vehicleType.value}',
                                    style: getTextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    'Order ${controller.orderNumber.value}',
                                    style: getTextStyle(fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Arriving in ${controller.arrivalTime.value}',
                                          style: getTextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Obx(
                                        () => IconButton(
                                          icon: Image.asset(
                                            IconPath.love,
                                            color: controller.isLoved.value
                                                ? Color(0xFF6B6B6B)
                                                : Colors.red,
                                            width: 24,
                                            height: 24,
                                          ),
                                          onPressed: () {
                                            controller.isLoved.value =
                                                !controller.isLoved.value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

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
                                color: Color(0xFF6B6B6B),
                              ),
                              Icon(
                                Icons.fiber_manual_record,
                                size: 10,
                                color: Color(0xFF6B6B6B),
                              ),
                              LocationRowWidget(
                                iconPath: IconPath.deliveredIcon,
                                title: 'Deliver to (Recipent: Joseph Low)',
                                address: 'Blk 222 Sengkang Ave 2, S530222',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rate rider',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '+1',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB38F00),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Your feeback helps us to improve your experience!',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ReviewRating(),
                            SizedBox(width: 6),
                            Text(
                              'Rate to earn',
                              style: getTextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'What influenced your rating?',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '+1',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB38F00),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: 26),
                        TwoSideIconText(
                          leftImage: IconPath.yellowDot,
                          leftText: 'Fast delivery',
                          rightImage: IconPath.greyDot,
                          rightText: 'Slow in delivery',
                        ),
                        SizedBox(height: 16),
                        TwoSideIconText(
                          leftImage: IconPath.yellowDot,
                          leftText: 'Item/s delivered ingood condition',
                          rightImage: IconPath.greyDot,
                          rightText: 'tem/s delivered inbad condition',
                        ),
                        SizedBox(height: 40),

                        Button(
                          buttonText: 'Slow in delivery',
                          textColor: Colors.black,
                          backgroundColor: Colors.amber,
                          onPressed: () {
                            Get.to(RateRiderTip());
                          },
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
