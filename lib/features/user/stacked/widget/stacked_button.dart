import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/stacked/widget/stacked_one_way_round_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../stacked_controller/stacked_controller.dart';

class StackedButtonWidget extends StatelessWidget {
  const StackedButtonWidget({super.key, required this.controller});

  final StackedLocationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRound = controller.isRoundTrip.value;

      return Column(
        children: [
          Card(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleTripType(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isRound
                            ? AppColors.primaryButtonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "One way",
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleTripType(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isRound
                            ? AppColors.primaryButtonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        "Round",
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: isRound
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Center(
                            child: Image.asset(
                              IconPath.exparess,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Text(
                            'Fixed route',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          StackedOneWayRoundWidget(
                            controller: StackedLocationController(),
                            title: 'Collected from (Sender: Athena Lin)',
                            subtitle: 'Sender Address',
                            icon: Image.asset(
                              IconPath.collectIcon,
                              width: 14,
                              height: 14,
                            ),
                          ),

                          SizedBox(height: 8),
                          StackedOneWayRoundWidget(
                            controller: StackedLocationController(),
                            title: 'Delivered from (Sender: Athena Lin)',
                            subtitle: 'Delivered Address',
                            icon: Image.asset(
                              IconPath.deliveredIcon,
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Center(
                            child: Image.asset(
                              IconPath.exparess,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Text(
                            'Fixed route',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          StackedOneWayRoundWidget(
                            controller: StackedLocationController(),
                            title: 'Collected from (Sender: Athena Lin)',
                            subtitle: 'Sender Address',
                            icon: Image.asset(
                              IconPath.collectIcon,
                              width: 14,
                              height: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          StackedOneWayRoundWidget(
                            controller: StackedLocationController(),
                            title: 'Delivered from (Sender: Athena Lin)',
                            subtitle: 'Delivered Address',
                            icon: Image.asset(
                              IconPath.deliveredIcon,
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
