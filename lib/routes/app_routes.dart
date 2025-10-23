import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nicholaslim80/features/onboarding/screen/onboarding_screen.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';
import 'package:nicholaslim80/features/user/acoount/screen/account_screen.dart';
import 'package:nicholaslim80/features/user/auth/login/screen/login_signup_screen.dart';
import 'package:nicholaslim80/features/user/auth/verification/screen/verification_screen.dart';
import 'package:nicholaslim80/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:nicholaslim80/features/user/home/screen/home_screen.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String loginScreen = '/loginScreen';
  static String verificationScreen = '/verificationScreen';
  static String homeScreen = '/homeScreen';
  static String ordersScreen = '/ordersScreen';
  static String accountScreen = '/accountScreen';
  static String bottomNavbarScreen = '/bottomnavbarScreen';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getverificationScreen() => verificationScreen;
  static String gethomeScreen() => homeScreen;
  static String getordersScreen() => ordersScreen;
  static String getaccountScreen() => accountScreen;
  static String getbottomNavbarScreen() => bottomNavbarScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(
      name: loginScreen,
      page: () => LoginSignupScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: verificationScreen,
      page: () => VerificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ordersScreen,
      page: () => OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: accountScreen,
      page: () => AccountScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNavbarScreen,
      page: () => BottomNavbarScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
