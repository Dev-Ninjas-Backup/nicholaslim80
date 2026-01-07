import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    _loadToken().then((_) => fetchRiders());
  }

  // ================= ADD RIDER =================
  Future<void> addRider() async {
    final phoneNumber = phoneController.text.trim();
    final email = emailController.text.trim();

    if (phoneNumber.isEmpty && email.isEmpty) {
      EasyLoading.showError("Please enter phone number or email");
      return;
    }

    if (phoneNumber.isNotEmpty && phoneNumber.length <= 4) {
      EasyLoading.showError("Phone number too short");
      return;
    }

    if (token.value.isEmpty) await _loadToken();

    try {
      isLoading.value = true;
      EasyLoading.show(status: "Adding rider...");

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
          response.body?['success'] == true) {
        phoneController.text = "+65";
        emailController.clear();
        Get.back();

        EasyLoading.showSuccess("Rider added successfully");

        await fetchRiders(); // refresh list
      } else {
        EasyLoading.showError(
          response.body?['message'] ?? "Failed to add rider",
        );
      }
    } catch (e) {
      print("[ADD RIDER] Exception: $e");
      EasyLoading.showError("Network error or server issue");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // ================= DELETE RIDER =================
  Future<void> deleteRider(int myRaiderId) async {
    if (token.value.isEmpty) await _loadToken();

    try {
      isLoading.value = true;
      EasyLoading.show(status: "Deleting rider...");

      final response = await _connect.delete(
        "${ApiEndPoint.deleteRaider}/$myRaiderId",
        headers: {
          "Authorization": "Bearer ${token.value}",
          "Content-Type": "application/json",
        },
      );

      print("[DELETE RIDER] Status Code: ${response.statusCode}");
      print("[DELETE RIDER] Response Body: ${response.body}");

      if (response.statusCode == 200 && response.body?['success'] == true) {
        // Remove from local list
        ridersList.removeWhere((rider) => rider['myRaiderId'] == myRaiderId);
        ridersList.refresh();

        EasyLoading.showSuccess("Rider deleted successfully");
        await fetchRiders(); // refresh list
      } else {
        EasyLoading.showError(
          response.body?['message'] ?? "Failed to delete rider",
        );
      }
    } catch (e) {
      print("[DELETE RIDER] Exception: $e");
      EasyLoading.showError("Network error or server issue");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // ================= GET RIDERS =================
  Future<void> fetchRiders() async {
    if (token.value.isEmpty) await _loadToken();

    try {
      isLoading.value = true;
      EasyLoading.show(status: "Fetching riders...");

      final response = await _connect.get(
        ApiEndPoint.getRaider,
        headers: {
          "Authorization": "Bearer ${token.value}",
          "Content-Type": "application/json",
        },
      );

      print("[FETCH RIDERS] Status Code: ${response.statusCode}");
      print("[FETCH RIDERS] Response Body: ${response.body}");

      if (response.statusCode == 200 && response.body?['success'] == true) {
        final List data = response.body['data']['data'] ?? [];
        ridersList.clear();

        for (var rider in data) {
          final raiderData = rider['raider'] ?? {};

          final riderMap = {
            'name': raiderData['raider_name'] ?? 'Unknown',
            'order-id': rider['find_by'] ?? 'Pending',
            'raiderId': raiderData['id'], // For display/avatar
            'myRaiderId': rider['id'], // ✅ For delete API
            'image': ImagePath.profile1,
          };

          ridersList.add(riderMap);
          loveState[riderMap['name']] = false;
        }

        print("[FETCH RIDERS] Fetched ${ridersList.length} riders.");
      } else {
        EasyLoading.showError(
          response.body?['message'] ?? "Unable to fetch riders",
        );
      }
    } catch (e) {
      print("[FETCH RIDERS] Exception: $e");
      EasyLoading.showError("Network error or server issue");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // ================= UI HELPERS =================
  void toggleLove(String name) {
    loveState[name] = !(loveState[name] ?? false);
  }

  void updateSwipeProgress(String name, double progress) {
    swipeProgress[name] = progress;
  }

  // ================= TOKEN =================
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
