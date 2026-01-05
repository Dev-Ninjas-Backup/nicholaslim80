import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';

class MyRidersController extends GetxController {
  var ridersList = <Map<String, dynamic>>[].obs;
  var loveState = <String, bool>{}.obs;
  var swipeProgress = <String, double>{}.obs;

  final phoneController = TextEditingController(text: "+65");
  final emailController = TextEditingController();

  final GetConnect _connect = GetConnect();
  var token = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken().then((_) => fetchRiders()); // screen load এ fetch
  }

  // ================= ADD RIDER =================
  Future<void> addRider() async {
    final phoneNumber = phoneController.text.trim();
    final email = emailController.text.trim();

    if (phoneNumber.isEmpty && email.isEmpty) {
      Get.snackbar(
        "Invalid Input",
        "Please enter phone number or email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (phoneNumber.isNotEmpty && phoneNumber.length <= 4) {
      Get.snackbar(
        "Invalid Phone",
        "Phone number too short",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (token.value.isEmpty) await _loadToken();

    try {
      isLoading.value = true;

      Map<String, dynamic> body = {"is_fav": false};
      if (phoneNumber.isNotEmpty) body["find_by"] = phoneNumber;
      if (email.isNotEmpty) body["email"] = email;

      final response = await _connect.post(
        ApiEndPoint.addRaider,
        body,
        headers: {
          "Authorization": "Bearer ${token.value}",
          "Content-Type": "application/json",
        },
      );

      print("[ADD RIDER] Status Code: ${response.statusCode}");
      print("[ADD RIDER] Response Body: ${response.body}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body?['data'] != null) {
        phoneController.text = "+65";
        emailController.clear();
        Get.back();

        Get.snackbar(
          "Success",
          "Rider added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchRiders(); // POST করার পর GET করে update
      } else {
        Get.snackbar(
          "Failed",
          response.body?['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("[ADD RIDER] Exception: $e");
      Get.snackbar(
        "Network/Error",
        "Server error or network issue occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= GET RIDERS =================
  Future<void> fetchRiders() async {
    if (token.value.isEmpty) await _loadToken();

    try {
      isLoading.value = true;

      final response = await _connect.get(
        ApiEndPoint.getRaider,
        headers: {
          "Authorization": "Bearer ${token.value}",
          "Content-Type": "application/json",
        },
      );

      print("[FETCH RIDERS] Status Code: ${response.statusCode}");
      print("[FETCH RIDERS] Response Body: ${response.body}");

      // ===== Corrected: response.body['data']['data'] =====
      if (response.statusCode == 200 &&
          response.body?['data'] != null &&
          response.body['data']['data'] != null) {
        final List data = response.body['data']['data'];
        ridersList.clear();

        for (var item in data) {
          final raider = item['raider'];
          final riderName = raider['raider_name']?.toString() ?? 'Unknown';
          final riderMap = {
            'name': riderName,
            'order-id': item['find_by']?.toString() ?? 'Pending',
            'image': ImagePath.profile1,
          };
          ridersList.add(riderMap);
          loveState[riderName] = false;
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Unauthorized",
          "Token expired or invalid. Please login again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Failed",
          response.body?['message'] ?? "Unable to fetch riders",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("[FETCH RIDERS] Exception: $e");
      Get.snackbar(
        "Network/Error",
        "Server error or network issue occurred",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLove(String name) {
    loveState[name] = !(loveState[name] ?? false);
  }

  void updateSwipeProgress(String name, double progress) {
    swipeProgress[name] = progress;
  }

  Future<void> _loadToken() async {
    token.value = await SharedPreferencesHelper.getAccessToken() ?? '';
    print("[TOKEN] Loaded: ${token.value}");
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
