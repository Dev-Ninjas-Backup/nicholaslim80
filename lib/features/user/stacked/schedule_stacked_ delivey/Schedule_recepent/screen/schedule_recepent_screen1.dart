import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_%20delivey/Schedule_recepent/widget/schedule_recepent_widget_st.dart';
import 'package:ZipBee/features/user/stacked/stacked_screen/stacked_screen.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/model/model.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/controller_sender/sender_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StackedSchedulRecepmenteScreen extends StatelessWidget {
  final StackedAddressModel? address;

  const StackedSchedulRecepmenteScreen({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// MAP Section
              SizedBox(
                height: 240,
                width: double.infinity,
                child: GoogleMapWidget(),
              ),

              /// FORM Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroungColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ScheduleRecipientWidgetST(
                  title: 'Recipient',
                  address: address,
                  onPressed: () async {
                    // Save destination via API, then update controller and navigate
                    final controller = Get.find<SenderController>();
                    final ok = await controller.saveDestination(type: 'RECEIVER');
                    if (ok) {
                      // Extract and store data in StackedLocationController
                      final locationController = Get.find<StackedLocationController>();
                      locationController.updateReceiverData(
                        AddressData(
                          id: 0, // Will be from API response if available
                          address: controller.addressController.text,
                          addressFromApr: controller.addressController.text,
                          floorUnit: controller.floorController.text,
                          contactName: controller.nameController.text,
                          contactNumber: controller.numberController.text,
                          noteToDriver: controller.noteController.text,
                          isSaved: controller.saveAddress.value,
                          type: 'RECEIVER',
                        ),
                      );
                      Get.to(() => StackedScreen());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
