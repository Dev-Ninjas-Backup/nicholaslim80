import 'dart:convert';
import 'package:ZipBee/features/user/google_map/widget/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/stacked/schedule_stacked_%20delivey/Schedule_recepent/service/destination_service.dart';
import 'package:http/http.dart' as http;

class RecipientController extends GetxController {
  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();
  final floorController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final noteController = TextEditingController();

  final isFormValid = false.obs;
  final saveAddress = false.obs;
  final isLoading = false.obs;
  final totalCost = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    postalCodeController.addListener(() {
      onPostalCodeChanged(postalCodeController.text);
      validateForm(); 
    });
    addressController.addListener(validateForm);
    floorController.addListener(validateForm);
    nameController.addListener(validateForm);
    numberController.addListener(validateForm);
  }

  void validateForm() {
    isFormValid.value =
        postalCodeController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        floorController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        numberController.text.isNotEmpty;
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

    void onPostalCodeChanged(String value) async {
    // সাধারণত ৫ বা ৬ ডিজিট হলে রিকোয়েস্ট পাঠানো ভালো (আপনার দেশের ফরম্যাট অনুযায়ী)
    if (value.length >= 5) {
      try {
        final String url =
            "https://maps.googleapis.com/maps/api/geocode/json?address=$value&key=$GoogleMapAPIKey";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            String formattedAddress = data['results'][0]['formatted_address'];

            // শুধু তখনই আপডেট করবে যদি এড্রেস ফিল্ড আগে থেকে এক না থাকে
            if (addressController.text != formattedAddress) {
              addressController.text = formattedAddress;
            }
          }
        }
      } catch (e) {
        debugPrint("Postal Code lookup error: $e");
      }
    }
  }

  /// Creates a destination record on the server and links it to order. Returns destination data on success, otherwise null.
  Future<Map<String, dynamic>?> saveDestination({String type = 'RECEIVER', required int orderId}) async {
    if (!isFormValid.value) return null;
    isLoading.value = true;
    EasyLoading.show(status: 'Saving...');

    final body = {
      'address': addressController.text,
      'postal_code': postalCodeController.text,
      'floor_unit': floorController.text,
      'contact_name': nameController.text,
      'contact_number': numberController.text,
      'note_to_driver': noteController.text,
      'is_saved': saveAddress.value,
      'type': type, // SENDER / RECEIVER
      'order_id': orderId,
    };

    // 1️⃣ POST: Create destination
    final destRes = await DestinationService.createDestination(body);
    final destSuccess = destRes['success'] as bool? ?? false;

    debugPrint('📊 CREATE DESTINATION - Success: $destSuccess');

    if (!destSuccess) {
      isLoading.value = false;
      EasyLoading.dismiss();
      final msg = (destRes['body'] as Map<String, dynamic>?)?['message'] ?? 'Failed to create destination';
      EasyLoading.showError(msg.toString());
      return null;
    }

    // Extract destination ID from nested response
    final destData = destRes['body'] as Map<String, dynamic>? ?? {};
    final dataWrapper = destData['data'] as Map<String, dynamic>? ?? {};
    
    // Try to extract ID from either 'result' or nested 'data'
    var actualDestData = (dataWrapper['result'] as Map<String, dynamic>?) ?? 
                         (dataWrapper['data'] as Map<String, dynamic>?) ?? 
                         {};
    
    debugPrint('✅ DESTINATION CREATED: ${jsonEncode(actualDestData)}');
    
    final destinationId = actualDestData['id'] as int? ?? 0;
    debugPrint('📋 Destination ID: $destinationId');

    if (destinationId == 0) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Invalid destination ID received');
      return null;
    }

    // 2️⃣ PATCH: Link destination to order (ONLY if CREATE succeeded)
    final stopType = type == 'SENDER' ? 'PICKUP' : 'DROP';
    final patchRes = await DestinationService.addDestinationToOrder(
      orderId: orderId,
      destinationId: destinationId,
      stopType: stopType,
    );
    final patchSuccess = patchRes['success'] as bool? ?? false;

    if (!patchSuccess) {
      isLoading.value = false;
      EasyLoading.dismiss();
      final msg = (patchRes['body'] as Map<String, dynamic>?)?['message'] ?? 'Failed to link destination';
      EasyLoading.showError(msg.toString());
      return null;
    }

    final patchData = patchRes['body'] as Map<String, dynamic>? ?? {};
    debugPrint('✅ DESTINATION LINKED: ${jsonEncode(patchData)}');
    
    final patchTotalCost = patchData['totalCost'] as num? ?? 0;
    totalCost.value = patchTotalCost.toDouble();
    debugPrint('💰 Total Cost Updated: \$${totalCost.value}');

    isLoading.value = false;
    EasyLoading.dismiss();
    EasyLoading.showSuccess('Order updated');

    return actualDestData;
  }

  @override
  void onClose() {
    postalCodeController.dispose();
    addressController.dispose();
    floorController.dispose();
    nameController.dispose();
    numberController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
