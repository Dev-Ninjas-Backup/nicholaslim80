import 'package:ZipBee/features/user/saved_places/add_places/service/location_service.dart';
import 'package:ZipBee/features/user/saved_places/controller/saved_places_controller.dart';
import 'package:ZipBee/features/user/saved_places/name_places/screen/name_places_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AddPlaceController extends GetxController {
  var suggestions = <dynamic>[].obs;
  var isLoading = false.obs;

  void searchAddress(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    isLoading.value = true;
    try {
      var result = await LocationService.getAutocomplete(query);
      suggestions.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void onLocationSelected(Map<String, dynamic> suggestion) async {
    String description = suggestion['description'] ?? "";
    String placeId = suggestion['place_id'] ?? "";

    var details = await LocationService.getPlaceDetails(placeId);

    if (details != null) {
      debugPrint("--- Selected Location Details ---");
      debugPrint("Description: $description");
      debugPrint("Latitude: ${details['lat']}");
      debugPrint("Longitude: ${details['lng']}");
      debugPrint("---------------------------------");

      // Pass the selected address to the saved-place flow and navigate to name input.
      final savedPlaceController = Get.find<SavedPlaceController>();
      savedPlaceController.selectAddress(description);
      Get.to(() => NamePlaceScreen());
    }
  }
}
