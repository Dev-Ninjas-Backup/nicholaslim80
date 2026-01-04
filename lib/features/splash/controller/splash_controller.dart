import 'package:get/get.dart';

import '../../../core/shared_prefference_service/shared_pref.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    //  Correct method
    final bool isLogin = await SharedPreferencesHelper.isLoggedIn();

    // Splash delay
    await Future.delayed(const Duration(seconds: 2));

    if (isLogin) {
      Get.offAllNamed(AppRoutes.bottomNavbarScreen);
    } else {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }
  }
}
