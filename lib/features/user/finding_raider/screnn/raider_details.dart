import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/common/widgets/custom_button.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/finding_raider/controller/rider_controller.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/custom_icon_text_button.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/location_row_widget.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/review_rateing.dart';
import 'package:share_plus/share_plus.dart';

class RaiderDetails extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();
  RaiderDetails({super.key});
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
                        SizedBox(height: 24),
                        Row(
                          spacing: 11,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              iconPosition: IconPosition.before,
                            ),
                            CustomIconTextButton(
                              text: 'Call',
                              iconPath: IconPath.call,
                              borderColor: Colors.black,
                              textColor: Colors.black,
                              backgroundColor: Colors.white,
                              onPressed: () {},
                              iconPosition: IconPosition.before,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReviewRating(
                              onRatingSelected: (rating) {},
                              initialRating: 0,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                '(243 Reviews)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
                        CustomButton(
                          label: "Share Ride Information",
                          onPressed: () {
                            final String referralLink =
                                "https://yourapp.com/referral?code";
                            final String message =
                                "Hey! Join this amazing app and earn rewards. Use my referral link: $referralLink";

                            Share.share(message, subject: "Invite to our app");
                          },
                          color: AppColors.primaryButtonColor,
                          textColor: AppColors.primaryFontColor,
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
