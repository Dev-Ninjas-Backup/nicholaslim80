import 'package:ZipBee/features/user/wallet/manage_payment/service/wallet_payment_method_service.dart';
import 'package:ZipBee/features/user/wallet/manage_payment/model/payment_card_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';

class ManagePaymentController extends GetxController {
  /// Loading State
  RxBool isAddingCard = false.obs;
  RxBool isFetchingCards = false.obs;
  RxInt deletingCardId = 0.obs;

  /// Card State
  RxBool hasCard = false.obs;
  RxString last4 = "".obs;
  RxString defaultStripeMethodId = "".obs;
  RxList<PaymentCardModel> savedCards = <PaymentCardModel>[].obs;

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
      isFetchingCards.value = true;
      final result = await WalletPaymentMethodService.getSavedCards();

      if (result['success'] == true && result['body'] is List) {
        final cards = (result['body'] as List)
            .whereType<Map<String, dynamic>>()
            .map(PaymentCardModel.fromJson)
            .toList();

        savedCards.assignAll(cards);

        final PaymentCardModel? primaryCard =
            cards
                .where((card) => card.isDefault)
                .cast<PaymentCardModel?>()
                .firstOrNull ??
            cards.firstOrNull;

        hasCard.value = primaryCard != null;
        last4.value = primaryCard?.last4 ?? "";
        defaultStripeMethodId.value = primaryCard?.stripeMethodId ?? "";
      } else {
        _clearCardState();
      }
    } catch (e) {
      _clearCardState();
    } finally {
      isFetchingCards.value = false;
    }
  }

  void _clearCardState() {
    savedCards.clear();
    hasCard.value = false;
    last4.value = "";
    defaultStripeMethodId.value = "";
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
      final setupResult = await WalletPaymentMethodService.createSetupIntent();

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
      final setupIntent = await Stripe.instance.retrieveSetupIntent(
        clientSecret,
      );

      final paymentMethodId = setupIntent.paymentMethodId;

      if (paymentMethodId.isEmpty) {
        EasyLoading.showError("Payment method not found");
        return;
      }

      /// 5️⃣ Save Card to Backend
      final result = await WalletPaymentMethodService.saveCard(
        paymentMethodId: paymentMethodId,
      );

      if (result['success'] != true) {
        EasyLoading.showError(
          result['body']?['message'] ?? "Failed to save card",
        );
        return;
      }

      await fetchSavedCard();
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

  Future<void> deleteCard(PaymentCardModel card) async {
    if (deletingCardId.value == card.id) return;

    try {
      deletingCardId.value = card.id;
      EasyLoading.show(status: "Deleting card...");

      final result = await WalletPaymentMethodService.deleteSavedCard(card.id);

      if (result['success'] != true) {
        EasyLoading.showError(
          result['body']?['message'] ?? "Failed to delete card",
        );
        return;
      }

      await fetchSavedCard();
      EasyLoading.showSuccess(
        result['body']?['message']?.toString() ?? "Card deleted successfully",
      );
    } catch (e) {
      EasyLoading.showError("Failed to delete card");
    } finally {
      deletingCardId.value = 0;
      EasyLoading.dismiss();
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
