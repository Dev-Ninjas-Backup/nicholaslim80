import 'package:ZipBee/core/controllers/app_controller.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/auth_controller.dart';
import 'package:ZipBee/features/user/home/controller/popup_controller.dart';
import 'package:ZipBee/features/user/home/controller/profile_controller.dart';
import 'package:ZipBee/features/user/home/model/delivery_type_model.dart';
import 'package:ZipBee/features/user/home/model/drawer_model.dart';
import 'package:ZipBee/features/user/home/model/order_response_model.dart';
import 'package:ZipBee/features/user/home/service/delivery_type_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/order_service.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final profileCtrl = Get.put(UserProfileController());
  final popupCtrl = Get.put(PopupController());
  final authCtrl = Get.put(AuthController());

  // UI States
  final deliveryType = ''.obs;
  final selectedVehicleId = RxnString();
  var drawerItem = <DrawerModel>[].obs;

  // Delivery types
  final deliveryTypes = <DeliveryTypeModel>[].obs;
  final isDeliveryLoading = false.obs;

  @override
  void onInit() {
    _initDrawer();
    _listenToProfileChanges();
    fetchDeliveryTypes();
    super.onInit();
  }

  void _listenToProfileChanges() {
    final appController = Get.find<AppController>();
    ever(
      appController.appRebuildTrigger,
      (_) => profileCtrl.fetchUserProfile(),
    );
  }

  // Create order method
  final isLoading = false.obs;
  final currentOrderId = RxnInt();

  void resetHomeSelection() {
    deliveryType.value = '';
    selectedVehicleId.value = null;
    currentOrderId.value = null;
  }

  void selectDeliveryType(DeliveryTypeModel selectedType) async {
    deliveryType.value = selectedType.name.toLowerCase();
    await _createOrderApi(selectedType.id);
  }

  Future<void> _createOrderApi(int deliveryTypeId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Processing...');

      final response = await OrderService.createOrder({
        "route_type": "ONE_WAY",
        "isFixed": false,
        "delivery_type_id": deliveryTypeId,
        "collect_time": "ASAP",
      }, deliveryType: deliveryType.value);

      if (response['statusCode'] == 201 || response['statusCode'] == 200) {
        final orderResponse = OrderResponseModel.fromJson(response['body']);
        if (orderResponse.success == true) {
          currentOrderId.value = orderResponse.data?.id;
          final resolvedDeliveryType =
              orderResponse.data?.deliveryType?.toLowerCase() ??
              deliveryType.value;
          EasyLoading.dismiss();

          await Get.toNamed(
            AppRoutes.stackedScreen,
            arguments: {
              'orderId': currentOrderId.value,
              'deliveryType': resolvedDeliveryType,
              'deliveryTypeId': deliveryTypeId,
              'order': orderResponse.data?.rawJson,
            },
          );

          resetHomeSelection();
        } else {
          EasyLoading.showError(
            orderResponse.message ?? "Could not create order",
          );
        }
      } else {
        EasyLoading.showError("Server Error ${response['statusCode']}");
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error creating order: $e');
      EasyLoading.showError("Something went wrong. $e");
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  // Fetch delivery types
  Future<void> fetchDeliveryTypes() async {
    try {
      isDeliveryLoading.value = true;
      final response = await DeliveryTypeService.getDeliveryTypes();

      if (response['statusCode'] == 200 && response['body'] != null) {
        final List rawData = response['body']['data']['data'];
        deliveryTypes.assignAll(
          rawData.map((json) => DeliveryTypeModel.fromJson(json)).toList(),
        );
      }
    } finally {
      isDeliveryLoading.value = false;
    }
  }

  void _initDrawer() {
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
        ontap: () => authCtrl.showLogoutDialog(),
      ),
    ]);
  }
}
