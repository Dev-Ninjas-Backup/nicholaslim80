import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/finding_raider/screnn/connecting_rider_page.dart';

class RiderController extends GetxController {
  var selectedFare = 0.obs;
  var riderName = 'Dylan Simpson'.obs;
  var vehicleType = 'Truck'.obs;
  var orderNumber = '1233'.obs;
  var arrivalTime = '10 min'.obs;
  var dateTime = '25 September 2025 / 9:40 am'.obs;
  RxBool firstActive = true.obs;
  RxBool secondActive = false.obs;

  final List<double> fareOptions = [1.2, 2.5, 4.5, 6.5];

  void selectFare(int index) {
    selectedFare.value = index;
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
