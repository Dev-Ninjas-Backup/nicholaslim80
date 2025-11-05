import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nicholaslim80/features/onboarding/screen/onboarding_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/quiz_congratulation/screen/quiz_congratulation_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/screen/app_coures_screen.dart';
import 'package:nicholaslim80/features/rider/app_course/try_agin/screen/try_agin_screen.dart';
import 'package:nicholaslim80/features/rider/app_quiz/screen/app_quiz_screen.dart';
import 'package:nicholaslim80/features/rider/driver_preference/distance_radius/screen/distance_radius_screen.dart';
import 'package:nicholaslim80/features/rider/driver_preference/screen/driver_preference_screen.dart';
import 'package:nicholaslim80/features/rider/rider_account/screen/rider_account_screen.dart';
import 'package:nicholaslim80/features/rider/rider_bottom_navbar/screen/rider_bottom_navbar_screen.dart';
import 'package:nicholaslim80/features/rider/rider_home/screen/rider_home_screen.dart';
import 'package:nicholaslim80/features/rider/rider_incentives/screen/incentives_screen.dart';
import 'package:nicholaslim80/features/rider/rider_records/screen/records_screen.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';
import 'package:nicholaslim80/features/user/home/my_riders/screen/my_riders.dart';
import 'package:nicholaslim80/features/user/wallet/add_funds/screen/user_add_funds.dart';
import 'package:nicholaslim80/features/user/wallet/my_wallet/screen/user_my_wallet.dart';
import 'package:nicholaslim80/features/user/notification/screen/user_notification1.dart';
import 'package:nicholaslim80/features/user/profile/screen/profile_screen.dart';
import 'package:nicholaslim80/features/user/auth/login/screen/login_signup_screen.dart';
import 'package:nicholaslim80/features/user/auth/verification/screen/verification_screen.dart';
import 'package:nicholaslim80/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:nicholaslim80/features/user/home/screen/home_screen.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/screen/refer_and_earn_screen.dart';
import 'package:nicholaslim80/features/user/saved_places/screen/saved_place_screenn.dart';

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
  static String referAndEarnScreen = '/referAndEarnScreen';
  static String myRidersScreen = '/myRidersScreen';

  static String riderBottomNavbarScreen = '/riderBottomNavbarScreen';
  static String riderHomeScreen = '/riderHomeScreen';
  static String incentivesScreen = '/incentivesScreen';
  static String recordsScreen = '/recordsScreen';
  static String riderAccountScreen = '/riderAccountScreen';

  //user notification
  static String userNotification = '/user/notification';
  static String userOrderDetails = '/userOrderDetails';
  static String savedPlaces = '/savedPlaces';
  //user wallet
  static String myWalletUser = "/User/myWalletUser";
  static String userAddFund = "/user/userAddFund";

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

  static String getriderBottomNavbarScreen() => riderBottomNavbarScreen;
  static String getriderHomeScreen() => riderHomeScreen;
  static String getincentivesScreen() => incentivesScreen;
  static String getrecordsScreen() => recordsScreen;
  static String getriderAccountScreen() => riderAccountScreen;
  static String getreferAndEarnScreen() => referAndEarnScreen;

  //user notification
  static String getUserNotification() => userNotification;
  static String getSavedPlaces() => savedPlaces;
  //user my wallet
  static String getmyWalletUser() => myWalletUser;
  static String getuserAddFund() => userAddFund;

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

    GetPage(
      name: riderBottomNavbarScreen,
      page: () => RiderBottomNavbarScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: riderHomeScreen,
      page: () => RiderHomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: incentivesScreen,
      page: () => IncentivesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: recordsScreen,
      page: () => RecordsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: riderAccountScreen,
      page: () => RiderAccountScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: referAndEarnScreen,
      page: () => ReferAndEarnScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myRidersScreen,
      page: () => MyRidersScreen(),
      transition: Transition.fadeIn,
    ),

    //user notification
    GetPage(name: userNotification, page: () => UserNotification()),
    GetPage(name: savedPlaces, page: () => SavedPlaceScreen()),
    //user my wallet
    GetPage(name: myWalletUser, page: () => UserMyWallet()),
    GetPage(name: userAddFund, page: () => UserAddFunds()),
  ];
}
