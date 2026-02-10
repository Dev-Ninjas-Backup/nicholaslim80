import 'package:ZipBee/features/user/wallet/manage_payment/service/wallet_payment_method_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';

class ManagePaymentController extends GetxController {
  RxBool isAddingCard = false.obs;

  /// 🔥 Card State
  RxBool hasCard = false.obs;
  RxString last4 = "".obs;

  @override
  void onInit() {
    super.onInit();

    Stripe.publishableKey = StripeKeys.stripePublicKey;
    Stripe.instance.applySettings();

    fetchSavedCard();
  }

  /// ===============================
  /// FETCH SAVED CARD FROM BACKEND
  /// ===============================
  Future<void> fetchSavedCard() async {
    try {
      final result = await WalletPaymentMethodService.getSavedCard();

      if (result['success']) {
        final data = result['body']?['data'];

        if (data != null && data['last4'] != null) {
          hasCard.value = true;
          last4.value = data['last4'].toString();
        } else {
          hasCard.value = false;
        }
      }
    } catch (e) {
      hasCard.value = false;
    }
  }

  /// ===============================
  /// ADD NEW CARD
  /// ===============================
  Future<void> onAddPayment() async {
    try {
      isAddingCard.value = true;
      EasyLoading.show(status: "Preparing payment method...");

      /// 1️⃣ Create SetupIntent
      final setupResult = await WalletPaymentMethodService.createSetupIntent();

      if (!setupResult['success']) {
        EasyLoading.dismiss();
        EasyLoading.showError("Setup failed");
        return;
      }

      final clientSecret = setupResult['body']?['clientSecret'];

      if (clientSecret == null) {
        EasyLoading.dismiss();
        EasyLoading.showError("Invalid client secret");
        return;
      }

      EasyLoading.dismiss();

      /// 2️⃣ Init PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          merchantDisplayName: StripeKeys.merchantDisplayName,
        ),
      );

      /// 3️⃣ Show PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      /// 4️⃣ Retrieve SetupIntent safely
      final setupIntent = await Stripe.instance.retrieveSetupIntent(
        clientSecret,
      );

      final paymentMethodId = setupIntent.paymentMethodId;

      /// 5️⃣ Save to backend
      final result = await WalletPaymentMethodService.saveCard(
        paymentMethodId: paymentMethodId,
      );

      if (!result['success']) {
        EasyLoading.showError(
          result['body']?['message'] ?? "Failed to save card",
        );
        return;
      }

      /// 🔥 Update UI instantly
      final cardLast4 = result['body']?['data']?['last4'] ?? "";

      hasCard.value = true;
      last4.value = cardLast4;

      hasCard.value = true;
      last4.value = cardLast4?.toString() ?? "";

      EasyLoading.showSuccess("Card added successfully");
    } on StripeException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.error.localizedMessage ?? "Payment cancelled");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Something went wrong");
    } finally {
      isAddingCard.value = false;
    }
  }

  void onStripeTap() {}
  void onNetsTap() {}
  void onDbspayTap() {}
}
