import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/finding_raider/controller/rider_controller.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/button.dart';
import 'package:nicholaslim80/features/user/finding_raider/widget/location_row_widget.dart';

class FindingRiderPage extends StatelessWidget {
  final RiderController raidercontroller = Get.put(RiderController());

  FindingRiderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Image Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              ImagePath.map, // replace with your static map image path
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable Content Overlay
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
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

                        // Header
                        Center(
                          child: Text(
                            'Finding your rider',

                            style: getTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(() {
                          // ignore: unused_local_variable
                          final value = raidercontroller.firstActive.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 69,
                                height: 6,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Container(
                                width: 69,
                                height: 6,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey,

                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Good Fare, Your Request Gets Priority 2:00',
                            style: getTextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Pickup Location
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

                        _buildFareOptions(),
                        SizedBox(height: 20),
                        Center(
                          child: InkWell(
                            onTap: null, // no action
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              margin: EdgeInsets.only(top: 8), // spacing
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white, // PURE white
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: Offset(0, 1), // elevation = 1
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Add amount',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(Icons.add, size: 13, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Button(
                          buttonText: 'Share Ride Information',
                          textColor: Colors.black,
                          backgroundColor: Colors.amber,
                          onPressed: raidercontroller.navigateToConnectingRider,
                        ),
                        SizedBox(height: 24),

                        Center(
                          child: FilledButton(
                            onPressed: () => Get.back(),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              minimumSize: Size(0, 0), // prevent full width
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide(color: Colors.red, width: 1.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Cancel order',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Image.asset(
                                  IconPath.cencell,
                                  height: 14,
                                  width: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildFareOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(raidercontroller.fareOptions.length, (index) {
        return Obx(
          () => GestureDetector(
            onTap: () => raidercontroller.selectFare(index),
            child: Card(
              elevation: raidercontroller.selectedFare.value == index ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: raidercontroller.selectedFare.value == index
                  ? Colors.amber
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text(
                  'S\$${raidercontroller.fareOptions[index]}',
                  style: TextStyle(
                    color: raidercontroller.selectedFare.value == index
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
