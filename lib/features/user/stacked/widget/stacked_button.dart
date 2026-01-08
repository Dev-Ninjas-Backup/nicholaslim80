import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
// import 'package:ZipBee/features/user/stacked/widget/stacked_one_way_round_widget.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/screen/collect_from.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/controller/controller.dart';
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
                          // Sender section with edit button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                      'Collected from (Sender: ${controller.senderDisplayName})',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Obx(() => Text(
                                      controller.senderDisplayAddress,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(() => StackedCollectFormScreen(
                                    controller: Get.put(StackedCollectFormController()),
                                    addressType: 'SENDER',
                                  ));
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          // Receiver section with edit button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                      'Delivered to (Recipient: ${controller.receiverDisplayName})',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Obx(() => Text(
                                      controller.receiverDisplayAddress,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(() => StackedCollectFormScreen(
                                    controller: Get.put(StackedCollectFormController()),
                                    addressType: 'RECEIVER',
                                  ));
                                },
                              ),
                            ],
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
                          // Sender section with edit button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                      'Collected from (Sender: ${controller.senderDisplayName})',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Obx(() => Text(
                                      controller.senderDisplayAddress,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(() => StackedCollectFormScreen(
                                    controller: Get.put(StackedCollectFormController()),
                                    addressType: 'SENDER',
                                  ));
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Receiver section with edit button
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                      'Delivered to (Recipient: ${controller.receiverDisplayName})',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Obx(() => Text(
                                      controller.receiverDisplayAddress,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 18),
                                onPressed: () {
                                  Get.to(() => StackedCollectFormScreen(
                                    controller: Get.put(StackedCollectFormController()),
                                    addressType: 'RECEIVER',
                                  ));
                                },
                              ),
                            ],
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
