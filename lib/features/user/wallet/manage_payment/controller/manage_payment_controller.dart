import 'package:ZipBee/features/user/wallet/manage_payment/service/wallet_payment_method_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';

class ManagePaymentController extends GetxController {
  /// Loading State
  RxBool isAddingCard = false.obs;

  /// Card State
  RxBool hasCard = false.obs;
  RxString last4 = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initStripe();
    fetchSavedCard();
  }

  /// ===============================
  /// INIT STRIPE
  /// ===============================
  void _initStripe() {
    Stripe.publishableKey = StripeKeys.stripePublicKey;
    Stripe.instance.applySettings();
  }

  /// ===============================
  /// FETCH SAVED CARD FROM BACKEND
  /// ===============================
  Future<void> fetchSavedCard() async {
    try {
      final result = await WalletPaymentMethodService.getSavedCard();

      if (result['success'] == true) {
        final data = result['body']?['data'];

        if (data != null) {
          hasCard.value = true;
          last4.value = data['last4']?.toString() ?? "";
        } else {
          hasCard.value = false;
          last4.value = "";
        }
      } else {
        hasCard.value = false;
        last4.value = "";
      }
    } catch (e) {
      hasCard.value = false;
      last4.value = "";
    }
  }

  /// ===============================
  /// ADD NEW CARD
  /// ===============================
  Future<void> onAddPayment() async {
    if (isAddingCard.value) return;

    try {
      isAddingCard.value = true;

      EasyLoading.show(status: "Preparing payment method...");

      /// 1️⃣ Create SetupIntent
      final setupResult =
          await WalletPaymentMethodService.createSetupIntent();

      if (setupResult['success'] != true) {
        EasyLoading.dismiss();
        EasyLoading.showError("Setup failed");
        return;
      }

      final clientSecret = setupResult['body']?['clientSecret'];

      if (clientSecret == null || clientSecret.isEmpty) {
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

      /// 4️⃣ Retrieve SetupIntent
      final setupIntent =
          await Stripe.instance.retrieveSetupIntent(clientSecret);

      final paymentMethodId = setupIntent.paymentMethodId;

      if (paymentMethodId == null || paymentMethodId.isEmpty) {
        EasyLoading.showError("Payment method not found");
        return;
      }

      /// 5️⃣ Save Card to Backend
      final result = await WalletPaymentMethodService.saveCard(
        paymentMethodId: paymentMethodId,
      );

      if (result['success'] != true) {
        EasyLoading.showError(
            result['body']?['message'] ?? "Failed to save card");
        return;
      }

      /// 🔥 SUCCESS → Update UI
      final responseData = result['body'];

      hasCard.value = true;
      last4.value = responseData?['last4']?.toString() ?? "";

      EasyLoading.showSuccess("Card added successfully");

    } on StripeException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
        e.error.localizedMessage ?? "Payment cancelled",
      );
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Something went wrong");
    } finally {
      isAddingCard.value = false;
    }
  }

  /// ===============================
  /// STRIPE TILE TAP
  /// ===============================
  void onStripeTap() {
    if (!hasCard.value) {
      onAddPayment();
    }
  }
}
