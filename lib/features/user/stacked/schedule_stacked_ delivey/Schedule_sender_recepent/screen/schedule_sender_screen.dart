import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/widget_sender/text_filed_widget.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_ delivey/Schedule_sender_recepent/controller/sender_schedule_controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_screen/stacked_screen.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/model/model.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_ delivey/Schedule_recepent/screen/schedule_recepent_screen1.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class StackedSenderScheduleScreen extends StatelessWidget {
  final StackedAddressModel? address;

  const StackedSenderScheduleScreen({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    final SenderScheduleController controller = Get.put(
      SenderScheduleController(),
    );

    // Prefill if address provided and fields empty
    if (address != null) {
      if (controller.addressController.text.isEmpty) {
        controller.addressController.text = address!.addressFromApr.isNotEmpty ? address!.addressFromApr : address!.address;
      }
      if (controller.floorController.text.isEmpty) controller.floorController.text = address!.floorUnit;
      if (controller.nameController.text.isEmpty) controller.nameController.text = address!.contactName;
      if (controller.numberController.text.isEmpty) controller.numberController.text = address!.contactNumber;
      controller.saveAddress.value = address!.isSaved;
    }

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
              /// MAP SECTION
              SizedBox(
                height: 240,
                width: double.infinity,
                child: GoogleMapWidget(),
              ),

              /// FORM SECTION
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroungColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sender",
                      style: getTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.postalCodeController,
                      label: "Postal Code*",
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.addressController,
                      label: "Address*",
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.floorController,
                      label: "Floor or unit no.*",
                      maxLines: 1,
                      maxLength: 120,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.nameController,
                      label: "Contact name*",
                      suffixIcon: Icon(Icons.person_outline),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.numberController,
                      label: "Contact number*",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: controller.noteController,
                      label: "Note to driver",
                      maxLines: 2,
                      maxLength: 120,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.saveAddress.value,
                            onChanged: (value) =>
                                controller.saveAddress.value = value ?? false,
                          ),
                        ),
                        Text(
                          "Save this address",
                          style: getTextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // CONFIRM BUTTON
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isFormValid.value
                              ? () async {
                                  final orderController = Get.find<StackedOrderController>();
                                  final orderId = orderController.lastOrderId;
                                  
                                  if (orderId == null) {
                                    EasyLoading.showError('Order ID not found. Please try again.');
                                    return;
                                  }

                                  final res = await controller.saveDestination(type: 'SENDER', orderId: orderId);
                                  if (res != null) {
                                    final data = res;

                                    // Update total cost in order controller
                                    if (controller.totalCost.value > 0) {
                                      orderController.totalAmount.value = controller.totalCost.value;
                                    }

                                    // Extract and store data in StackedLocationController
                                    final locationController = Get.find<StackedLocationController>();
                                    final savedAddress = AddressData(
                                      id: (data['id'] as int?) ?? 0,
                                      address: data['address'] ?? controller.addressController.text,
                                      addressFromApr: data['address'] ?? controller.addressController.text,
                                      floorUnit: data['floor_unit'] ?? controller.floorController.text,
                                      contactName: data['contact_name'] ?? controller.nameController.text,
                                      contactNumber: data['contact_number'] ?? controller.numberController.text,
                                      noteToDriver: data['note_to_driver'] ?? controller.noteController.text,
                                      isSaved: (data['is_saved'] as bool?) ?? controller.saveAddress.value,
                                      type: data['type'] ?? 'SENDER',
                                    );

                                    locationController.updateSenderData(savedAddress);

                                    // If Add Stop flow requested, navigate to recipient screen to add a recipient stop
                                    final args = Get.arguments as Map<String, dynamic>?;
                                    if (args != null && args['navigateNextToRecipient'] == true) {
                                      Get.to(() => StackedSchedulRecepmenteScreen(), arguments: {'addAsStop': true});
                                    } else {
                                      // Regular flow: back to stacked screen
                                      Get.to(() => StackedScreen());
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isFormValid.value
                                ? Colors.yellow.shade700
                                : Colors.grey.shade300,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: getTextStyle(
                              fontSize: 18,
                              color: controller.isFormValid.value
                                  ? Colors.black
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
