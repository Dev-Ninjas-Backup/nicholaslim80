import 'package:flutter/material.dart'; // Required for TextEditingController
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';

class MyRidersController extends GetxController {
  // Sample riders list
  var ridersList = <Map<String, String>>[].obs;

  // Map to hold love/favorite state
  var loveState = <String, bool>{}.obs;
  var swipeProgress = <String, double>{}.obs;

  // Controller for the Dialog Text Field
  final phoneController = TextEditingController(text: "+65");

  @override
  void onInit() {
    super.onInit();
    ridersList.addAll([
      {
        'name': 'Dylan Simpson',
        'order-id': 'Order#1233',
        'image': ImagePath.profile1,
      },
      {
        'name': 'Christine Jason',
        'order-id': 'Order#1266',
        'image': ImagePath.profile2,
      },
      {
        'name': 'Michael Brown',
        'order-id': 'Order#1280',
        'image': ImagePath.profile3,
      },
    ]);

    // Initialize loveState with false for all riders
    for (var rider in ridersList) {
      loveState[rider['name'] ?? ''] = false;
    }
  }

  // --- ADD RIDER FUNCTION ---
  void addRider() {
    String phoneNumber = phoneController.text.trim();

    // Basic Validation: Ensure it's not just the prefix
    if (phoneNumber.length > 4) {
      // 1. Create a new rider map
      // Note: In a real app, you'd fetch the name/image from a DB using the phone number
      var newRider = {
        'name': 'Rider $phoneNumber', 
        'order-id': 'Pending: Order#${1000 + ridersList.length}',
        'image': ImagePath.profile1, // Default image
      };

      // 2. Update the list and the loveState map
      ridersList.add(newRider);
      loveState[newRider['name']!] = false;

      // 3. Clear the text field and close the dialog
      phoneController.text = "+65";
      Get.back(); 

      Get.snackbar(
        "Success", 
        "Rider added to your list",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white
      );
    } else {
      Get.snackbar(
        "Invalid Input", 
        "Please enter a valid phone number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white
      );
    }
  }

  // Toggle favorite
  void toggleLove(String name) {
    if (loveState.containsKey(name)) {
      loveState[name] = !loveState[name]!;
    }
  }

  // Call this on swipe update
  void updateSwipeProgress(String name, double progress) {
    swipeProgress[name] = progress;
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}