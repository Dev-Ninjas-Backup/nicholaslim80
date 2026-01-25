import 'package:ZipBee/features/user/saved_places/add_places/service/location_service.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AddPlaceController extends GetxController {
  // সাজেশনের লিস্ট এবং লোডিং স্টেট
  var suggestions = <dynamic>[].obs;
  var isLoading = false.obs;

  // ১. সার্চ মেথড (Screen থেকে কল হবে)
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

  // ২. সিলেকশন মেthod (Screen থেকে কল হবে)
  void onLocationSelected(Map<String, dynamic> suggestion) async {
    String description = suggestion['description'] ?? "";
    String placeId = suggestion['place_id'] ?? "";

    // Lat/Lng নিয়ে আসা
    var details = await LocationService.getPlaceDetails(placeId);

    if (details != null) {
      debugPrint("--- Selected Location Details ---");
      debugPrint("Description: $description");
      debugPrint("Latitude: ${details['lat']}");
      debugPrint("Longitude: ${details['lng']}");
      debugPrint("---------------------------------");

      // আপনার পরবর্তী স্ক্রিন বা লজিক এখানে লিখুন
    }
  }
}