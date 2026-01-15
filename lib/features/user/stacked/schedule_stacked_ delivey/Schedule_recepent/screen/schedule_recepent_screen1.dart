import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/features/user/google_map/widget/google_map_widget.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_%20delivey/Schedule_recepent/widget/schedule_recepent_widget_st.dart';
import 'package:ZipBee/features/user/stacked/stacked_screen/stacked_screen.dart';
import 'package:ZipBee/features/user/stacked/stacked_controller/stacked_controller.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/model/model.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/controller_sender/sender_controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
                  isAdditionalStop: (Get.arguments as Map<String, dynamic>?)?['isAdditionalStop'] ?? false,
                  onPressed: () async {
                    // Get controller with the correct tag
                    final String controllerTag = (Get.arguments as Map<String, dynamic>?)?['isAdditionalStop'] ?? false ? 'additional_stop' : 'primary';
                    final controller = Get.find<SenderController>(tag: controllerTag);
                    final orderController = Get.find<StackedOrderController>();
                    final orderId = orderController.lastOrderId;
                    
                    if (orderId == null) {
                      EasyLoading.showError('Order ID not found. Please try again.');
                      return;
                    }

                    final res = await controller.saveDestination(type: 'RECEIVER', orderId: orderId);
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
                        type: data['type'] ?? 'RECEIVER',
                      );

                      final args = Get.arguments as Map<String, dynamic>?;

                      if (args != null && args['addAsStop'] == true) {
                        // Add as additional recipient stop
                        locationController.addRecipientStop(savedAddress);
                        // Return to stacked screen
                        Get.to(() => StackedScreen());
                      } else {
                        // Primary receiver update
                        locationController.updateReceiverData(savedAddress);
                        Get.to(() => StackedScreen());
                      }
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
