import 'dart:convert';
import 'dart:math';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/controllers/app_controller.dart';
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

  // পরিবর্তন এখানে: স্ট্যাটিক ডাটা রিমুভ করে খালি লিস্ট রাখা হয়েছে
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
      await SharedPreferencesHelper.logout();
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  // Popup Handling
  Future<void> checkAndShowPopup(BuildContext context) async {
    final response = await DashboardPopupService.fetchPopups();

    if (response['success'] == true && response['data'] != null) {
      List popups = response['data'];

      // শুধুমাত্র Active পপআপগুলো ফিল্টার করা
      List activePopups = popups.where((p) => p['isActive'] == true).toList();

      if (activePopups.isNotEmpty) {
        // র‍্যান্ডমলি একটি অবজেক্ট সিলেক্ট করা
        final random = Random();
        final selectedPopup = activePopups[random.nextInt(activePopups.length)];

        _showPopupDialog(context, selectedPopup);
      }
    }
  }

  void _showPopupDialog(BuildContext context, Map<String, dynamic> data) {
    Get.dialog(
      Dialog(
        backgroundColor:
            Colors.transparent, // ব্যাকগ্রাউন্ড ট্রান্সপারেন্ট রাখা হয়েছে
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(
              0xFFFFF9E3,
            ), // আপনার ইমেজের হালকা হলুদ ব্যাকগ্রাউন্ড
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFD700),
              width: 1,
            ), // গোল্ডেন বর্ডার
          ),
          child: GestureDetector(
            onTap: () => _launchURL(data['redirect_link']),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Description Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Title
                          Text(
                            data['title'] ?? "Always here for you!",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description
                          GestureDetector(
                            onTap: () => _launchURL(data['redirect_link']),
                            child: Text(
                              data['desc'] ??
                                  "600k points to share! Click here to register now!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withAlpha(60),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Image Section
                    SizedBox(
                    width: 70,
                    height: 70,
                    child: data['image_link'] != null && data['image_link'].toString().isNotEmpty
                        ? Image.network(
                            data['image_link'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              IconPath.gift_Ad, 
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            IconPath.gift_Ad, 
                            fit: BoxFit.contain,
                          ),
                  ),
                  
                  ],
                ),
                const SizedBox(height: 10),
                // close button
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Color.fromARGB(255, 216, 213, 213)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('❌ Could not launch $url');
    }
  }

  void selectService(String service) => selectedService.value = service;
  void selectVehicle(String id) => selectedVehicleId.value = id;
  @override
  void onInit() {
    fetchUserProfile();

    // 🔄 Listen for profile changes from app controller
    final appController = Get.find<AppController>();
    ever(appController.appRebuildTrigger, (_) {
      debugPrint(
        '🔄 Profile changed detected in HomeController, refreshing data...',
      );
      fetchUserProfile();
    });

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
}
