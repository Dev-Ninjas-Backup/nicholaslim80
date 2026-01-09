import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_%20delivey/Schedule_recepent/service/destination_service.dart';

class SenderScheduleController extends GetxController {
  final addressController = TextEditingController();
  final floorController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final noteController = TextEditingController();

  final isFormValid = false.obs;
  final saveAddress = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    addressController.addListener(validateForm);
    floorController.addListener(validateForm);
    nameController.addListener(validateForm);
    numberController.addListener(validateForm);
  }

  void validateForm() {
    final isValid =
        addressController.text.isNotEmpty &&
        floorController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        numberController.text.isNotEmpty;
    isFormValid.value = isValid;
  }

  /// Save destination via API. Returns parsed response body on success, otherwise null.
  Future<Map<String, dynamic>?> saveDestination({String type = 'SENDER'}) async {
    if (!isFormValid.value) return null;
    isLoading.value = true;
    EasyLoading.show(status: 'Saving...');

    final body = {
      'address': addressController.text,
      'floor_unit': floorController.text,
      'contact_name': nameController.text,
      'contact_number': numberController.text,
      'note_to_driver': noteController.text,
      'is_saved': saveAddress.value,
      'type': type,
    };

    final res = await DestinationService.createDestination(body);

    isLoading.value = false;
    EasyLoading.dismiss();

    final status = res['statusCode'] as int? ?? 500;
    if (status == 201) {
      EasyLoading.showSuccess('Destination saved');
      return (res['body'] as Map<String, dynamic>?);
    } else {
      final msg = (res['body'] as Map<String, dynamic>?)?['message'] ?? 'Failed';
      EasyLoading.showError(msg.toString());
      return null;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    floorController.dispose();
    nameController.dispose();
    numberController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
