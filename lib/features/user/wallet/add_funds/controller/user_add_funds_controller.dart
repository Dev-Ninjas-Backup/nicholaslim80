import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/preset_amounts_cache_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_payment_service.dart';
import 'package:ZipBee/features/user/wallet/add_payment_method/service/wallet_payment_service.dart';

class UserAddFundsController extends GetxController {
  final RxList<double> presetAmounts = <double>[10, 20, 40, 100].obs;
  final RxInt selectedIndex = 0.obs;

  final TextEditingController customAmountController =
      TextEditingController();
  final RxDouble selectedAmount = 10.0.obs;

  final RxBool isStripeSelected = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingPaymentMethod = false.obs;
  final RxBool showPaymentMethodForm = false.obs;

  /// 🔹 Saved Card State
  final RxBool hasSavedCard = false.obs;
  final RxString savedCardLast4 = ''.obs;
  final RxString savedCardBrand = ''.obs;

  bool get isAddButtonEnabled =>
      selectedAmount.value > 0 && isStripeSelected.value;

  @override
  void onInit() {
    super.onInit();
    Stripe.publishableKey = StripeKeys.stripePublicKey;
    _loadCachedPresetAmounts();
  }

  // ================= LOAD CACHE =================

  Future<void> _loadCachedPresetAmounts() async {
    final cached =
        await PresetAmountsCacheService.getCachedAmounts();
    presetAmounts.assignAll(cached);

    if (cached.isNotEmpty) {
      selectedAmount.value = cached.first;
      selectedIndex.value = 0;
    }
  }

  // ================= PRESET =================

  void onPresetTap(int index) {
    selectedIndex.value = index;
    customAmountController.clear();
    selectedAmount.value = presetAmounts[index];
  }

  void onCustomAmountChanged(String value) {
    selectedIndex.value = -1;
    selectedAmount.value = double.tryParse(value) ?? 0;
  }

  // ================= ADD TO CACHE =================

  Future<void> onAddToCache() async {
    final amount =
        double.tryParse(customAmountController.text) ?? 0;

    if (amount <= 0) {
      EasyLoading.showError("Enter valid amount");
      return;
    }

    await PresetAmountsCacheService.addAmount(amount);
    await _loadCachedPresetAmounts();

    customAmountController.clear();
    selectedIndex.value = presetAmounts.indexOf(amount);
    selectedAmount.value = amount;

    EasyLoading.showSuccess("Amount added");
  }

  // ================= STRIPE =================

  void onToggleStripe() {
    isStripeSelected.toggle();
  }

  void togglePaymentMethodForm() {
    showPaymentMethodForm.toggle();
  }

  // ================= ADD PAYMENT METHOD =================

  Future<void> addPaymentMethod() async {
    try {
      isAddingPaymentMethod.value = true;
      EasyLoading.show(status: 'Opening Stripe...');

      final setupResult =
          await WalletPaymentService.createSetupIntent();

      final clientSecret =
          setupResult['body']?['clientSecret'];

      if (clientSecret == null || clientSecret.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError("Invalid setup intent");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          merchantDisplayName:
              StripeKeys.merchantDisplayName,
          style: ThemeMode.light,
        ),
      );

      EasyLoading.dismiss();

      /// 🔥 Show Stripe bottom sheet
      await Stripe.instance.presentPaymentSheet();

      /// 🔥 Get SetupIntent result
      final setupIntent =
          await Stripe.instance.retrieveSetupIntent(
        clientSecret,
      );

      final paymentMethodId =
          setupIntent.paymentMethodId;

      if (paymentMethodId.isEmpty) {
        EasyLoading.showError(
            "Failed to get payment method");
        return;
      }

      /// 🔥 Save card to backend
      final saveResult =
          await WalletPaymentService.saveCard(
        paymentMethodId: paymentMethodId,
        cardHolderName: null,
        lastFourDigits: null,
        cardBrand: null,
      );

      if (!saveResult['success']) {
        EasyLoading.showError("Failed to save card");
        return;
      }

      /// ✅ UPDATE UI STATE
      hasSavedCard.value = true;
      savedCardBrand.value =
          saveResult['body']?['data']?['brand'] ?? 'Visa';
      savedCardLast4.value =
          saveResult['body']?['data']?['last4'] ?? '4242';

      showPaymentMethodForm.value = false;

      EasyLoading.showSuccess("Card added successfully");
    } catch (e) {
      EasyLoading.showError("Stripe error: $e");
    } finally {
      isAddingPaymentMethod.value = false;
    }
  }

  // ================= ADD FUNDS =================

  Future<void> onAddFunds() async {
    if (!isAddButtonEnabled) {
      EasyLoading.showError("Select valid amount");
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: "Processing payment...");

      final response =
          await AddFundsPaymentService.addMoneyToWallet(
        amount: selectedAmount.value,
        currency: 'sgd',
      );

      final clientSecret =
          response['body']?['data']?['clientSecret'];

      if (clientSecret == null) {
        EasyLoading.dismiss();
        EasyLoading.showError("Payment init failed");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName:
              StripeKeys.merchantDisplayName,
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      EasyLoading.dismiss();
      EasyLoading.showSuccess("Funds added!");

      await PresetAmountsCacheService.addAmount(
          selectedAmount.value);
      await _loadCachedPresetAmounts();

      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Payment failed");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }
}
