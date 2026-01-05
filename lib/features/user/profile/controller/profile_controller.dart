import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/features/user/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  var userProfile = UserModel(username: '', email: '', phone: '').obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var profileItem = <ProfileModel>[].obs; // List to store ProfileModel data

  Future<String?> getStoredAccessToken() async {
    return await SharedPreferencesHelper.getAccessToken();
  }

  Future<void> fetchUserProfile() async {
    final token = await getStoredAccessToken();

    if (token == null) {
      errorMessage('No access token found');
      return;
    }

    isLoading(true); // Start loading
    errorMessage(''); // Reset any previous error message

    final url = ApiEndPoint.profile;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var parsedResponse = json.decode(response.body);
        userProfile.value = UserModel.fromJson(parsedResponse);

        // Update profileItem based on the fetched user data
        profileItem.clear();
        profileItem.add(
          ProfileModel(title: 'Username', subtitle: userProfile.value.username),
        );
        profileItem.add(
          ProfileModel(title: 'Email', subtitle: userProfile.value.email),
        );
        profileItem.add(
          ProfileModel(title: 'Phone', subtitle: userProfile.value.phone),
        );
      } else {
        errorMessage('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Error: $error');
    } finally {
      isLoading(false); // Stop loading
    }
  }

  @override
  void onInit() {
    fetchUserProfile(); // Fetch the user profile on initialization
    super.onInit();
  }
}
