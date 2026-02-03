import 'dart:convert';
import 'dart:math';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/service/socket_service.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/model/drawer_model.dart';
import 'package:ZipBee/features/user/home/service/dashboard_popup_service.dart';
import 'package:ZipBee/features/user/home/widgets/logout_dailog_widget.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final userName = 'Good Morning!'.obs;
  final parcelStatus = 'Live delivery status'.obs;

  final walletBalance = 0.0.obs;
  final availablePoints = 0.obs;

  final selectedService = 'Standard'.obs;
  final selectedVehicleId = RxnString();

  final vehicles = <Map<String, dynamic>>[].obs;

  final deliveryType = 'standard'.obs;

  String get parcelStatusText {
    if (deliveryType.value == 'express') return 'Express Delivery';
    if (deliveryType.value == 'standard') return 'Standard Delivery';
    if (deliveryType.value == 'stacked') return 'Stacked Delivery';
    return 'Standard Delivery';
  }

  void selectDeliveryType(String type) {
    deliveryType.value = type;
  }

  var drawerItem = <DrawerModel>[].obs;

  final SocketService _socketService = SocketService();

  Future<void> fetchUserProfile() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;
      debugPrint("Fetching profile token:  $token");

      final response = await http.get(
        Uri.parse(ApiEndPoint.profile),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          final userId = data['id'].toString();
          await SharedPreferencesHelper.saveUserId(userId);
          debugPrint('💾 Saved User ID after signup: $userId');
          
          userName.value =
              "Good Morning, ${data['username']?.toString().trim() ?? ''}";
          walletBalance.value = (data['currentWalletBalance'] != null)
              ? double.tryParse(data['currentWalletBalance'].toString()) ?? 0
              : 0;
          availablePoints.value = (data['current_coin_balance'] != null)
              ? int.tryParse(data['current_coin_balance'].toString()) ?? 0
              : 0;

          debugPrint(
            "Profile loaded: wallet=${walletBalance.value}, points=${availablePoints.value}",
          );

          // 🔌 Connect to Socket.IO after successful profile fetch
          _connectToSocket(token);
        } else {
          debugPrint(" Profile API returned success=false");
        }
      } else {
        debugPrint(" Profile API failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(" PROFILE ERROR: $e");
    }
  }

  // 🔌 Connect to Socket.IO
  Future<void> _connectToSocket(String token) async {
    try {
      final socketService = SocketService();
      await socketService.connect(token);
      debugPrint('🔌 Socket connection initiated');
    } catch (e) {
      debugPrint('❌ Socket connection failed: $e');
    }
  }

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

  Future<void> logout() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      if (token == null || token.isEmpty) {
        await SharedPreferencesHelper.logout();
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }

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
        debugPrint("Logout API failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("LOGOUT ERROR: $e");
    } finally {
      // 🔌 Disconnect socket on logout
      final socketService = SocketService();
      socketService.disconnect();

      await SharedPreferencesHelper.logout();
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  void selectService(String service) => selectedService.value = service;
  void selectVehicle(String id) => selectedVehicleId.value = id;
  @override
  void onInit() {
    fetchUserProfile();
    connectSocket();

    drawerItem.addAll([
      DrawerModel(
        iconUrl: IconPath.notificationIcon2,
        iconname: "Notifications",
        ontap: () => Get.toNamed(AppRoutes.getUserNotification()),
      ),
      DrawerModel(
        iconUrl: IconPath.savedIcon,
        iconname: "Saved Places",
        ontap: () => Get.toNamed(AppRoutes.savedPlaces),
      ),
      DrawerModel(
        iconUrl: IconPath.walletIcon,
        iconname: "My Wallet",
        ontap: () => Get.toNamed(AppRoutes.myWalletUser),
      ),
      DrawerModel(
        iconUrl: IconPath.referIcon,
        iconname: "Refer & Earn",
        ontap: () => Get.toNamed(AppRoutes.getreferAndEarnScreen()),
      ),
      DrawerModel(
        iconUrl: IconPath.ridersicon,
        iconname: "My Riders",
        ontap: () => Get.toNamed(AppRoutes.myRidersScreen),
      ),
      DrawerModel(
        iconUrl: IconPath.supportIcon,
        iconname: "Support",
        ontap: () => Get.toNamed(AppRoutes.supportScreen),
      ),
      DrawerModel(
        iconUrl: IconPath.logOutIcon,
        iconname: "Logout",
        ontap: () => showLogoutDialog(),
      ),
    ]);

    super.onInit();
  }

  void connectSocket() async{
    final token = await SharedPreferencesHelper.getAccessToken();
    await _socketService.connect(token ?? "");
    
  }
}
