import 'package:ZipBee/core/controllers/app_controller.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/home/controller/auth_controller.dart';
import 'package:ZipBee/features/user/home/controller/popup_controller.dart';
import 'package:ZipBee/features/user/home/controller/profile_controller.dart';
import 'package:ZipBee/features/user/home/model/drawer_model.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final profileCtrl = Get.put(UserProfileController());
  final popupCtrl = Get.put(PopupController());
  final authCtrl = Get.put(AuthController());

  // UI States
  final deliveryType = 'standard'.obs;
  final selectedVehicleId = RxnString();
  var drawerItem = <DrawerModel>[].obs;

  @override
  void onInit() {
    _initDrawer();
    _listenToProfileChanges();
    super.onInit();
  }

  void selectDeliveryType(String type) => deliveryType.value = type;

  void _listenToProfileChanges() {
    final appController = Get.find<AppController>();
    ever(appController.appRebuildTrigger, (_) => profileCtrl.fetchUserProfile());
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
