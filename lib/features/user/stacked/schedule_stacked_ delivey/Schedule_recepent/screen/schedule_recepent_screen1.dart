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
                    final res = await controller.saveDestination(type: 'RECEIVER');
                    if (res != null) {
                      final data = (res['data'] as Map<String, dynamic>?) ?? res;

                      // Debug print the exact payload that will be shown on StackedScreen ✅
                      debugPrint('Saved Destination (recipient):');
                      debugPrint('address: ${data['address']}');
                      debugPrint('addressFromApr: ${data['addressFromApr'] ?? data['address']}');
                      debugPrint('floor_unit: ${data['floor_unit']}');
                      debugPrint('contact_name: ${data['contact_name']}');
                      debugPrint('contact_number: ${data['contact_number']}');
                      debugPrint('note_to_driver: ${data['note_to_driver']}');
                      debugPrint('is_saved: ${data['is_saved']}');
                      debugPrint('type: ${data['type']}');

                      // Extract and store data in StackedLocationController
                      final locationController = Get.find<StackedLocationController>();
                      locationController.updateReceiverData(
                        AddressData(
                          id: (data['id'] as int?) ?? 0,
                          address: data['address'] ?? controller.addressController.text,
                          addressFromApr: data['addressFromApr'] ?? controller.addressController.text,
                          floorUnit: data['floor_unit'] ?? controller.floorController.text,
                          contactName: data['contact_name'] ?? controller.nameController.text,
                          contactNumber: data['contact_number'] ?? controller.numberController.text,
                          noteToDriver: data['note_to_driver'] ?? controller.noteController.text,
                          isSaved: (data['is_saved'] as bool?) ?? controller.saveAddress.value,
                          type: data['type'] ?? 'RECEIVER',
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
