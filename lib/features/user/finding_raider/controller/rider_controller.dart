import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/model/payment_option_model.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/connecting_rider_page.dart';
import 'package:get/get.dart';


class RiderController extends GetxController {
  var selectedFare = 0.obs;
  var riderName = 'Dylan Simpson'.obs;
  var vehicleType = 'Truck'.obs;
  var orderNumber = '1233'.obs;
  var arrivalTime = '10 min'.obs;
  var dateTime = '25 September 2025 / 9:40 am'.obs;
  RxBool firstActive = true.obs;
  RxBool secondActive = false.obs;
  var isLoved = false.obs;
  var rating = 0.obs;
  //Rate Raider Tip
  var selectedMethod = 0.obs;
  final paymentOptions = <PaymentOptionModel>[
    PaymentOptionModel(
      title: 'Stripe',
      subtitle: 'Mastercard ****456',
      assetPath: IconPath.stripe,
    ),
    PaymentOptionModel(
      title: 'Wallet (with balance)',
      subtitle: 'S\$10.50',
      assetPath: IconPath.wallet,
    ),
    PaymentOptionModel(
      title: 'Cash',
      subtitle: 'To be paid by sender or recipient',
      assetPath: IconPath.cash,
    ),
  ];

  void selectMethod(int index) {
    selectedMethod.value = index;
  }

  var selectedRaiderTip = 0.obs;
  final List<double> raiderTipOptions = [10, 20, 40, 100];

  void selectTip(int index) {
    selectedRaiderTip.value = index;
  }

  //Finding Rider Controller
  final List<double> fareOptions = [1.2, 2.5, 4.5, 6.5];

  void selectFare(int index) {
    selectedFare.value = index;
  }

  void setRating(int value) {
    rating.value = value;
  }

  void navigateToConnectingRider() {
    Get.toNamed('/connecting-rider');
  }

  void navigateToNextPage() {
    firstActive.value = true;
    secondActive.value = true;
    Get.to(() => ConnectingRiderPage());
  }
}

// PaymentOption class (for reference, if not imported)
