import 'package:get/get.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

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
      Get.offAllNamed(AppRoutes.getLoginScreen());
    }
  }
}
