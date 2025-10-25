import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nicholaslim80/features/onboarding/screen/onboarding_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/quiz_congratulation/screen/quiz_congratulation_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/screen/app_coures_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/try_agin/screen/try_agin_screen.dart';
import 'package:nicholaslim80/features/rider/app_quiz/screen/app_quiz_screen.dart';
import 'package:nicholaslim80/features/rider/driver_preference/distance_radius/screen/distance_radius_screen.dart';
import 'package:nicholaslim80/features/rider/driver_preference/screen/driver_preference_screen.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';
import 'package:nicholaslim80/features/user/profile/screen/profile_screen.dart';
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
  static String appQuizScreen = '/appQuizScreen';
  static String appCouresScreen = '/appCouresScreen';
  static String quizCongratulationScreen = '/quizCongratulationScreen';
  static String tryAginScreen = '/tryAginScreen';
  static String driverPreferenceScreen = '/driverPreferenceScreen';
  static String distanceRadiusScreen = '/distanceRadiusScreen';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getverificationScreen() => verificationScreen;
  static String gethomeScreen() => homeScreen;
  static String getordersScreen() => ordersScreen;
  static String getaccountScreen() => accountScreen;
  static String getbottomNavbarScreen() => bottomNavbarScreen;
  static String getappQuizScreen() => appQuizScreen;
  static String getappCouresScreen() => appCouresScreen;
  static String getquizCongratulationScreen() => quizCongratulationScreen;
  static String gettryAginScreen() => tryAginScreen;
  static String getdriverPreferenceScreen() => driverPreferenceScreen;
  static String getdistanceRadiusScreen() => distanceRadiusScreen;

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
      page: () => ProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNavbarScreen,
      page: () => BottomNavbarScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: appQuizScreen,
      page: () => AppQuizScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: appCouresScreen,
      page: () => AppCouresScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: quizCongratulationScreen,
      page: () => QuizCongratulationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: tryAginScreen,
      page: () => TryAginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: driverPreferenceScreen,
      page: () => DriverPreferenceScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: distanceRadiusScreen,
      page: () => DistanceRadiusScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
