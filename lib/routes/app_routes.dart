import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';

  static String getSplashScreen() => splashScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
  ];
}
