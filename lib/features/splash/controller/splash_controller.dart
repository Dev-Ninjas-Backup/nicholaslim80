import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await SharedPreferencesHelper.getAccessToken();

    if (token == null || token.isEmpty) {
      Get.offAllNamed(AppRoutes.getOnboardingScreen());
    } else {
      Get.offAllNamed(AppRoutes.getbottomNavbarScreen());
    }
  }
}
