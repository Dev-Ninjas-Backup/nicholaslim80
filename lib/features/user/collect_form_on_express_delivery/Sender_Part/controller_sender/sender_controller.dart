import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_%20delivey/Schedule_recepent/service/destination_service.dart';

class SenderController extends GetxController {
  // Text Editing Controllers for each input field
  final addressController = TextEditingController();
  final floorController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final noteController = TextEditingController();

  // Observable boolean to track if the form is valid
  final isFormValid = false.obs;

  // Observable boolean for the checkbox
  final saveAddress = false.obs;

  // Loading indicator for network calls
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to required fields to trigger validation on change
    addressController.addListener(validateForm);
    floorController.addListener(validateForm);
    nameController.addListener(validateForm);
    numberController.addListener(validateForm);
  }

  // Checks if all required fields are non-empty
  void validateForm() {
    final isValid =
        addressController.text.isNotEmpty &&
        floorController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        numberController.text.isNotEmpty;
    isFormValid.value = isValid;
  }

  void clearForm() {
    addressController.clear();
    floorController.clear();
    nameController.clear();
    numberController.clear();
    noteController.clear();
    saveAddress.value = false;
    isFormValid.value = false;
  }

  /// Creates a destination record on the server. Returns parsed response body on success, otherwise null.
  Future<Map<String, dynamic>?> saveDestination({String type = 'RECEIVER'}) async {
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

  // Clean up the controllers when the controller is disposed
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
