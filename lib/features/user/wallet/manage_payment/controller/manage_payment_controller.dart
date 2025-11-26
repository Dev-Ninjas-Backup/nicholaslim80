import 'package:get/get.dart';

class ManagePaymentController extends GetxController {
  RxBool hasCard = true.obs;
  RxBool hasNets = false.obs;
  RxBool hasDbspay = false.obs;

  void onAddPayment() {
    Get.snackbar("Add Payment", "Navigate to add payment method");
  }

  void onStripeTap() {
    Get.snackbar("Stripe", "Stripe Card Selected");
  }

  void onNetsTap() {
    Get.snackbar("NETS", "Add NETS Card");
  }

  void onDbspayTap() {
    Get.snackbar("DBS Paylah", "Link Paylah/PayNow");
  }
}
