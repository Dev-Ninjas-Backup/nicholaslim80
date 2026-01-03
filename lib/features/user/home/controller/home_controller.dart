import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/auth/login/controller/login_signup_controller.dart';
import 'package:nicholaslim80/features/user/home/model/drawer_model.dart';
import 'package:nicholaslim80/features/user/home/widgets/logout_dailog_widget.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

import '../../../../core/api_end_point/api_end_point.dart';

class HomeController extends GetxController {
  var controller = Get.put(LoginSignupController());
  final userName = 'Good Morning!'.obs;
  final parcelStatus = 'Live delivery status'.obs;

  final walletBalance = 127.45.obs;
  final availablePoints = 500.obs;

  final selectedService = 'Standard'.obs;

  final vehicles = <Map<String, dynamic>>[
    {
      'id': 'instant',
      'title': 'Instant Delivery',
      'subtitle': '2-3km · 30mins delivery',
      'weight': '20 to 50kg',
      'priceFrom': 10,
      'image': AssetImage(ImagePath.vehicles2),
    },
    {
      'id': 'road',
      'title': 'Road Transport',
      'subtitle': '1-2 days delivery',
      'weight': '100 to 500kg',
      'priceFrom': 70,
      'image': AssetImage(ImagePath.vehicles1),
    },
    {
      'id': 'truck',
      'title': 'Heavy Truck',
      'subtitle': '3-5 days delivery',
      'weight': '500 to 2000kg',
      'priceFrom': 220,
      'image': AssetImage(ImagePath.vehicles2),
    },
    {
      'id': 'bike',
      'title': 'Two Wheeler',
      'subtitle': 'Local fast delivery',
      'weight': '0 to 20kg',
      'priceFrom': 5,
      'image': AssetImage(ImagePath.vehicles1),
    },
  ].obs;

  final selectedVehicleId = RxnString();

  // Show logout dialog
  void showLogoutDialog() {
    Get.dialog(
      LogoutDialog(
        onConfirm: () {
          logout();
        },
      ),
      barrierDismissible: false,
    );
  }

  // Logout function: calls API, clears local data, navigates to login
  Future<void> logout() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      if (token == null || token.isEmpty) {
        // No token, just clear local data and navigate
        await SharedPreferencesHelper.clearAllData();
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }

      // Call logout API
      final response = await http.post(
        Uri.parse(ApiEndPoint.logOut),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Logout API success");
      } else {
        debugPrint("Logout API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("LOGOUT ERROR: $e");
    } finally {
      // Clear local data and navigate to login
      await SharedPreferencesHelper.clearAllData();
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  void selectService(String service) => selectedService.value = service;
  void selectVehicle(String id) => selectedVehicleId.value = id;

  var drawerItem = <DrawerModel>[].obs;

  @override
  void onInit() {
    drawerItem.addAll([
      DrawerModel(
        iconUrl: IconPath.notificationIcon2,
        iconname: "Notifications",
        ontap: () {
          Get.toNamed(AppRoutes.getUserNotification());
        },
      ),
      DrawerModel(
        iconUrl: IconPath.savedIcon,
        iconname: "Saved Places",
        ontap: () {
          Get.toNamed(AppRoutes.savedPlaces);
        },
      ),
      DrawerModel(
        iconUrl: IconPath.walletIcon,
        iconname: "My Wallet",
        ontap: () {
          Get.toNamed(AppRoutes.myWalletUser);
        },
      ),
      DrawerModel(
        iconUrl: IconPath.referIcon,
        iconname: "Refer & Earn",
        ontap: () {
          Get.toNamed(AppRoutes.getreferAndEarnScreen());
        },
      ),
      DrawerModel(
        iconUrl: IconPath.ridersicon,
        iconname: "My Riders",
        ontap: () {
          Get.toNamed(AppRoutes.myRidersScreen);
        },
      ),
      DrawerModel(
        iconUrl: IconPath.supportIcon,
        iconname: "Support",
        ontap: () {
          Get.toNamed(AppRoutes.supportScreen);
        },
      ),
      DrawerModel(
        iconUrl: IconPath.logOutIcon,
        iconname: "Logout",
        ontap: () {
          showLogoutDialog();
        },
      ),
    ]);
    super.onInit();
  }
}
