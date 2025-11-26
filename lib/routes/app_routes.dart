import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:nicholaslim80/features/onboarding/screen/onboarding_screen.dart';
import 'package:nicholaslim80/features/splash/screen/splash_screen.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/express_delivery_to_sendr_or_recepmeant/screen/express_sender_or_recepmeant.dart';
import 'package:nicholaslim80/features/user/express_delivery_1/screen/express_delivery_1.dart';
import 'package:nicholaslim80/features/user/Express_Delivary_Faq/Screen/express_faq.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/connecting_rider_page.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/finding_rider_page.dart';
import 'package:nicholaslim80/features/user/home/my_riders/screen/my_riders.dart';
import 'package:nicholaslim80/features/user/user_support/screen/support_screen.dart';
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
  static String supportScreen = '/supportScreen';
  static String findingRider = '/finding-rider';
  static String connectingRider = '/connecting-rider';

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
  //express delivery
  static String expressDelivery1 = "/expressDelivery1";
  static String expressFaq = "/expressFaq";
  static String expressSenderOrRecepment = "/expressSenderOrRecepment";
  static String savedPlaceScreen = "/savedPlaceScreen";

  // static String scheduledelivery = "/scheduledelivery";

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
  static String getexpressDelivery1() => expressDelivery1;
  static String getexpressFaq() => expressFaq;

  static String getriderBottomNavbarScreen() => riderBottomNavbarScreen;
  static String getriderHomeScreen() => riderHomeScreen;
  static String getincentivesScreen() => incentivesScreen;
  static String getrecordsScreen() => recordsScreen;
  static String getriderAccountScreen() => riderAccountScreen;
  static String getreferAndEarnScreen() => referAndEarnScreen;
  static String getsavedPlaceScreen() => savedPlaceScreen;

  //user notification
  static String getUserNotification() => userNotification;
  static String getSavedPlaces() => savedPlaces;
  //user my wallet
  static String getmyWalletUser() => myWalletUser;
  static String getuserAddFund() => userAddFund;
  //express delivery
  static String getexpressSenderOrRecepment() => expressSenderOrRecepment;
  static String getconnectingRider() => connectingRider;
  static String getfindingRider() => findingRider;
  // static String scheduledelivery() => scheduledelivery;

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
      name: referAndEarnScreen,
      page: () => ReferAndEarnScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myRidersScreen,
      page: () => MyRidersScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: supportScreen,
      page: () => SupportScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: expressDelivery1,
      page: () => ExpressDelivery1(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: expressFaq,
      page: () => ExpressFaq(),
      transition: Transition.fadeIn,
    ),

    //user notification
    GetPage(name: userNotification, page: () => UserNotification()),
    GetPage(name: savedPlaces, page: () => SavedPlaceScreen()),
    //user my wallet
    GetPage(name: myWalletUser, page: () => UserMyWallet()),
    GetPage(name: userAddFund, page: () => UserAddFunds()),
    //express delivery
    GetPage(
      name: expressSenderOrRecepment,
      page: () => ExpressToSenderOrRecepment(),
    ),
    GetPage(name: connectingRider, page: () => ConnectingRiderPage()),
    GetPage(name: findingRider, page: () => FindingRiderPage()),
    GetPage(
      name: savedPlaceScreen,
      page: () => SavedPlaceScreen(),
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: scheduledelivery,
    //   page: () => ScheduleDelivery(),
    //   transition: Transition.fadeIn,
    // ),
  ];
}
