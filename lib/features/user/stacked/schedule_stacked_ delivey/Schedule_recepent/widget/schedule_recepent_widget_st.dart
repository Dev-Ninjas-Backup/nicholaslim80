import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/controller_sender/sender_controller.dart';
import 'package:ZipBee/features/user/collect_form_on_express_delivery/Sender_Part/widget_sender/text_filed_widget.dart';
import 'package:ZipBee/features/user/stacked/stacked_collect_from/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ScheduleRecipientWidgetST extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final StackedAddressModel? address;

  const ScheduleRecipientWidgetST({
    super.key,
    required this.title,
    required this.onPressed,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SenderController());

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        CustomTextField(
          controller: controller.addressController,
          label: "Address*",
        ),
        SizedBox(height: 10),

        CustomTextField(
          controller: controller.floorController,
          label: "Details Address (Floor, Building, Street)*",
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

        Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.saveAddress.value,
                onChanged: (v) => controller.saveAddress.value = v ?? false,
              ),
            ),
            Text(
              "Save this address",
              style: getTextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 26),

        /// CONFIRM BUTTON
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isFormValid.value
                  ? onPressed
                  : null, // <-- use parent callback
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
    );
  }
}
