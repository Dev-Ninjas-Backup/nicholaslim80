import 'package:get/get.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

import '../../../core/shared_prefference_service/shared_pref.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    final bool? isLogin = await SharedPreferencesHelper.checkLogin();
    if (isLogin != null && isLogin) {
      Get.offNamed(AppRoutes.getbottomNavbarScreen());
      return;
    }
    await Future.delayed(Duration(seconds: 3));
    Get.offNamed(AppRoutes.getOnboardingScreen());
  }
}
