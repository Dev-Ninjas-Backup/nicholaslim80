import 'package:get/get.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/finding_raider/model/payment_option_model.dart';
import 'package:ZipBee/features/user/finding_raider/screnn/connecting_rider_page.dart';
import 'package:ZipBee/features/user/finding_raider/services/place_order_service.dart';

class RiderController extends GetxController {
  // ================= ORDER =================
   RxInt orderId = 0.obs;

  // ================= BASIC INFO =================
  RxInt selectedFare = 0.obs;

  RxString riderName = 'Dylan Simpson'.obs;
  RxString vehicleType = 'Truck'.obs;
  RxString arrivalTime = '10 min'.obs;
  RxString dateTime = '25 September 2025 / 9:40 am'.obs;

  RxBool firstActive = true.obs;
  RxBool secondActive = false.obs;

  // ================= LOCATION =================
  RxDouble pickupLat = 0.0.obs;
  RxDouble pickupLng = 0.0.obs;

  RxString pickupName = ''.obs;
  RxString pickupAddress = ''.obs;
  RxString dropName = ''.obs;
  RxString dropAddress = ''.obs;

  void setPickupLocation(double lat, double lng) {
    pickupLat.value = lat;
    pickupLng.value = lng;
    print('📍 Pickup set: $lat, $lng');
  }

  void setLocationFromApi({
    required String pickupName,
    required String pickupAddress,
    required String dropName,
    required String dropAddress,
  }) {
    this.pickupName.value = pickupName;
    this.pickupAddress.value = pickupAddress;
    this.dropName.value = dropName;
    this.dropAddress.value = dropAddress;
  }

  // ================= RATING =================
  RxInt rating = 0.obs;
  void setRating(int value) => rating.value = value;

  // ================= PAYMENT =================
  RxInt selectedMethod = 0.obs;

  final paymentOptions = <PaymentOptionModel>[
    PaymentOptionModel(
      title: 'Stripe',
      subtitle: 'Temporarily unavailable',
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

  void selectMethod(int index) => selectedMethod.value = index;

  // ================= FARE =================
  final List<double> fareOptions = [1.2, 2.5, 4.5, 6.5];
  void selectFare(int index) => selectedFare.value = index;

  // ================= TIP =================
  RxInt selectedRaiderTip = 0.obs;
  final List<double> raiderTipOptions = [10, 20, 40, 100];
  void selectTip(int index) => selectedRaiderTip.value = index;

  // ================= API STATES =================
  RxBool isPlacingOrder = false.obs;
  RxBool isCancelling = false.obs;

  // ================= PLACE ORDER =================
  Future<void> placeOrder() async {
    if (isPlacingOrder.value) return;

    isPlacingOrder.value = true;

    try {
      final success = await PlaceOrderService.placeOrder(
        orderId: orderId.value,
        paymentMethod: _paymentMethod(),
        paymentMethodId: _paymentMethodId(),
      );

      if (success) {
        // ✅ TEMP until backend sends names
        setLocationFromApi(
          pickupName: 'Pickup Location',
          pickupAddress: 'Selected on map',
          dropName: 'Drop Location',
          dropAddress: 'Selected destination',
        );

        firstActive.value = false;
        secondActive.value = true;

        Get.to(() => ConnectingRiderPage());
      } else {
        Get.snackbar('Order Failed', 'Please try again');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isPlacingOrder.value = false;
    }
  }

  // ================= CANCEL ORDER =================
  Future<void> cancelOrder({required String reason}) async {
    if (isCancelling.value) return;

    isCancelling.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      Get.snackbar('Order Cancelled', reason);
    } finally {
      isCancelling.value = false;
    }
  }

  // ================= PAYMENT LOGIC (BACKEND SAFE) =================
  /// Stripe OFF → treated as COD

  String _paymentMethod() {
    switch (selectedMethod.value) {
      case 1:
        return 'WALLET';
      case 2:
        return 'COD';
      default:
        return 'COD';
    }
  }

  String _paymentMethodId() {
    if (selectedMethod.value == 1) {
      return 'wallet_balance';
    }
    return '';
  }
}
