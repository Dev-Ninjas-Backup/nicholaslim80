import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nicholaslim80/features/onboarding/screen/onboarding_screen.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';
import 'package:nicholaslim80/features/user/auth/login/screen/login_signup_screen.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String loginScreen = '/loginScreen';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(
      name: loginScreen,
      page: () => LoginSignupScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
