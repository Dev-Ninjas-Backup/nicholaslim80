import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/stacked/widget/stacked_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../stacked_controller/stacked_controller.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_ delivey/Schedule_sender_recepent/screen/schedule_sender_screen.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_ delivey/Schedule_recepent/screen/schedule_recepent_screen1.dart';

class StackedSelectLocationWidget extends StatelessWidget {
  const StackedSelectLocationWidget({super.key, required this.controller});

  final StackedLocationController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          StackedButtonWidget(controller: controller),
          SizedBox(height: 10),
          Divider(),
          StackedCustomAddButton(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class StackedCustomAddButton extends StatelessWidget {
  const StackedCustomAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,

          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(Icons.add),
        label: Text(
          "Add Stop",
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          final loc = Get.find<StackedLocationController>();

          // If sender not selected, first collect sender then navigate to recipient add flow
          if (loc.senderData.value == null) {
            Get.to(() => StackedSenderScheduleScreen(), arguments: {'navigateNextToRecipient': true});
            return;
          }

          // If receiver not selected, go to recipient screen (add as primary)
          if (loc.receiverData.value == null) {
            Get.to(() => StackedSchedulRecepmenteScreen(), arguments: {'addAsStop': false});
            return;
          }

          // Both selected: go to recipient screen to add additional stop
          Get.to(() => StackedSchedulRecepmenteScreen(), arguments: {'addAsStop': true});
        },
      ),
    );
  }
}
