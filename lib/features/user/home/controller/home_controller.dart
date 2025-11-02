import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/auth/login/controller/login_signup_controller.dart';
import 'package:nicholaslim80/features/user/home/model/drawer_model.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class HomeController extends GetxController {
  var controller = Get.put(LoginSignupController());
  final userName = 'Good Morning!'.obs;
  final parcelStatus = 'Your parcel delivered to destination'.obs;

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

  void selectService(String service) => selectedService.value = service;
  void selectVehicle(String id) => selectedVehicleId.value = id;

  var drawerItem = [].obs;
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
        ontap: () {},
      ),

      DrawerModel(
        iconUrl: IconPath.ridersicon,
        iconname: "My Riders",
        ontap: () {},
      ),

      DrawerModel(
        iconUrl: IconPath.supportIcon,
        iconname: "Support",
        ontap: () {},
      ),

      DrawerModel(
        iconUrl: IconPath.logOutIcon,
        iconname: "Logout",
        ontap: () {
          controller.logout();
        },
      ),
    ]);
    super.onInit();
  }
}
