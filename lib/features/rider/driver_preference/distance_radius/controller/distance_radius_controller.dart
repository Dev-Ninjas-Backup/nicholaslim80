import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceRadiusController extends GetxController {
  var isOffline = false.obs;
  var isAutoPopup = false.obs;
  RxDouble radiusKm = 5.0.obs;

  void increaseRadius() {
    if (radiusKm.value < 50) radiusKm.value += 1;
  }

  void toggleOffline(bool value) {
    isOffline.value = value;
  }

  void decreaseRadius() {
    if (radiusKm.value > 1) radiusKm.value -= 1;
  }

  void saveRadius(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Radius saved: ${radiusKm.value.toInt()} Km')),
    );
  }
}
