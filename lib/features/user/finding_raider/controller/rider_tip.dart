import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/finding_raider/controller/review_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../bottom_navbar/screen/bottom_navbar_screen.dart';

class RiderTipController extends GetxController {
  /// ---------------- RIDER INFO (from review screen) ----------------
  var riderId = 0.obs;
  var riderName = "".obs;
  var riderImage = "".obs;
  var riderRating = 0.0.obs;

  /// ---------------- TIP OPTIONS ----------------
  final List<double> raiderTipOptions = [2, 5, 10, 20, 50];
  var selectedRaiderTip = 0.obs;

  double get selectedAmount => raiderTipOptions[selectedRaiderTip.value];

  /// ---------------- PAYMENT ----------------
  var selectedPaymentIndex = 0.obs;
  var selectedPaymentTitle = "Cash".obs;

  /// For ONLINE_PAY (Stripe)
  String? paymentMethodId;

  /// Payment options list for your existing PaymentOptionWidget
  final paymentOptions = [
    {"title": "Cash", "method": "COD"},
    {"title": "Wallet", "method": "WALLET"},
    {"title": "Stripe", "method": "ONLINE_PAY"},
  ];

  /// ---------------- INIT (receive from ReviewController) ----------------
  @override
  void onInit() {
    super.onInit();

    /// get previous controller data automatically
    final review = Get.find<ReviewController>();

    try {
      riderId.value = review.actualRiderId.value;
      riderName.value = review.riderName.value;
      riderImage.value = review.riderImage.value;
      riderRating.value = review.averageRating.value;
    } catch (_) {}
  }

  /// ---------------- TIP SELECTION ----------------
  void selectTip(int index) {
    selectedRaiderTip.value = index;
  }

  /// ---------------- PAYMENT SELECTION ----------------
  void selectPayment(int index, {String? stripeMethodId}) {
    selectedPaymentIndex.value = index;
    selectedPaymentTitle.value = paymentOptions[index]["title"].toString();

    if (paymentOptions[index]["method"] == "ONLINE_PAY") {
      paymentMethodId = stripeMethodId;
    }
  }

  String get paymentMethod =>
      paymentOptions[selectedPaymentIndex.value]["method"].toString();

  /// ---------------- SUBMIT TIP API ----------------
  Future<void> submitTip() async {
    if (riderId.value == 0) {
      EasyLoading.showError("Rider not found");
      return;
    }

    try {
      EasyLoading.show(status: "Processing tip...");

      final token = await SharedPreferencesHelper.getAccessToken();

      final body = {
        "paymentMethod": paymentMethod, // COD / WALLET / ONLINE_PAY
        "paymentMethodId": paymentMethod == "ONLINE_PAY"
            ? paymentMethodId
            : null,
        "amount": selectedAmount,
      };

      final uri = Uri.parse("${ApiEndPoint.baseUrl}/tips/${riderId.value}/tip");

      final res = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        EasyLoading.showSuccess("Tip sent successfully ❤️");
        Get.to(BottomNavbarScreen());
      } else {
        EasyLoading.showError("Tip failed (${res.statusCode})");
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }
}
