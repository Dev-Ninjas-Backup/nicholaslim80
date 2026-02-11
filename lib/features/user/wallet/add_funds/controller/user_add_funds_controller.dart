import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/preset_amounts_cache_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_payment_service.dart';
import 'package:ZipBee/features/user/wallet/add_payment_method/service/wallet_payment_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/stripe_payment_sheet_handler.dart';

class UserAddFundsController extends GetxController {
  final RxList<double> presetAmounts =
      RxList<double>([10.0, 20.0, 40.0, 100.0]);

  final RxInt selectedIndex = 0.obs;
  final TextEditingController customAmountController =
      TextEditingController();
  final RxDouble selectedAmount = 10.0.obs;

  final RxBool isStripeSelected = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingPaymentMethod = false.obs;
  final RxBool showPaymentMethodForm = false.obs;

  /// 🔥 NEW VARIABLES
  final RxString savedCardBrand = ''.obs;
  final RxString savedCardLast4 = ''.obs;
  final RxBool hasSavedCard = false.obs;

  bool get isAddButtonEnabled =>
      selectedAmount.value > 0 && isStripeSelected.value;

  @override
  void onInit() {
    super.onInit();
    Stripe.publishableKey = StripeKeys.stripePublicKey;
    _loadCachedPresetAmounts();
  }

  Future<void> _loadCachedPresetAmounts() async {
    final cached = await PresetAmountsCacheService.getCachedAmounts();
    presetAmounts.assignAll(cached);

    if (cached.isNotEmpty) {
      selectedAmount.value = cached[0];
      selectedIndex.value = 0;
    }
  }

  void onPresetTap(int index) {
    selectedIndex.value = index;
    customAmountController.clear();
    selectedAmount.value = presetAmounts[index];
  }

  void onCustomAmountChanged(String value) {
    selectedIndex.value = -1;
    selectedAmount.value = double.tryParse(value) ?? 0;
  }

  void onToggleStripe() {
    isStripeSelected.toggle();
  }

  Future<void> onAddToCache() async {
    final amount =
        double.tryParse(customAmountController.text) ?? 0;

    if (amount <= 0) {
      EasyLoading.showError('Enter valid amount');
      return;
    }

    await PresetAmountsCacheService.addAmount(amount);
    await _loadCachedPresetAmounts();
    customAmountController.clear();
    EasyLoading.showSuccess('Added to preset');
  }

  void togglePaymentMethodForm() {
    showPaymentMethodForm.toggle();
  }

  // ==========================================================
  // 🔥 ADD PAYMENT METHOD
  // ==========================================================

  Future<void> addPaymentMethod() async {
    try {
      isAddingPaymentMethod.value = true;
      EasyLoading.show(status: "Creating setup intent...");

      final setupResult =
          await WalletPaymentService.createSetupIntent();

      if (!setupResult['success']) {
        EasyLoading.dismiss();
        EasyLoading.showError(
            setupResult['body']['message'] ??
                "Failed to create setup intent");
        return;
      }

      final clientSecret =
          setupResult['body']['clientSecret'];

      EasyLoading.dismiss();
      EasyLoading.show(status: "Opening Stripe...");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          merchantDisplayName:
              StripeKeys.merchantDisplayName,
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final setupIntent =
          await Stripe.instance.retrieveSetupIntent(
              clientSecret);

      final paymentMethodId =
          setupIntent.paymentMethodId;

      EasyLoading.dismiss();
      EasyLoading.show(status: "Saving card...");

      final saveResult =
          await WalletPaymentService.saveCard(
        paymentMethodId: paymentMethodId,
        cardHolderName: null,
        lastFourDigits: null,
        cardBrand: null,
      );

      EasyLoading.dismiss();

      if (!saveResult['success']) {
        EasyLoading.showError(
            saveResult['body']['message'] ??
                "Failed to save card");
        return;
      }

      /// 🔥 UPDATE UI DYNAMICALLY
      final data = saveResult['body'];

      savedCardBrand.value =
          data['type'] ?? 'CARD';

      savedCardLast4.value =
          data['last4'] ?? '';

      hasSavedCard.value = true;
      isStripeSelected.value = true;

      showPaymentMethodForm.value = false;

      EasyLoading.showSuccess(
          "Payment method added successfully");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Failed: $e");
    } finally {
      isAddingPaymentMethod.value = false;
    }
  }

  // ==========================================================
  // 💰 ADD FUNDS
  // ==========================================================

  Future<void> onAddFunds() async {
    if (!isAddButtonEnabled) {
      EasyLoading.showError(
          "Please select valid amount");
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: "Processing...");

      // Call Add Money API
      debugPrint('➡️ Step 2: Calling Add Money API');
      final response = await AddFundsPaymentService.addMoney(
        amount: selectedAmount.value,
        currency: "sgd",
      );


      EasyLoading.dismiss();
      EasyLoading.show(
          status: "Opening payment sheet...");

      final result =
          await StripePaymentSheetHandler
              .initiatePayment(
        amount: selectedAmount.value,
        orderId: 0,
      );

      EasyLoading.dismiss();

      if (result != null) {
        EasyLoading.showSuccess(
            "Funds added successfully");

        await PresetAmountsCacheService
            .addAmount(selectedAmount.value);

        await _loadCachedPresetAmounts();

        await Future.delayed(
            const Duration(seconds: 1));

        Get.back();
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Payment failed: $e");
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
