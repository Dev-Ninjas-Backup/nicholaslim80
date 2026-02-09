import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/preset_amounts_cache_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_payment_service.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/stripe_payment_sheet_handler.dart';

class UserAddFundsController extends GetxController {
  final RxList<double> presetAmounts = RxList<double>([10.0, 20.0, 40.0, 100.0]);
  final RxInt selectedIndex = 0.obs;

  final TextEditingController customAmountController = TextEditingController();
  final RxDouble selectedAmount = 10.0.obs;

  final RxBool isStripeSelected = true.obs;
  final RxBool isLoading = false.obs;

  bool get isAddButtonEnabled =>
      selectedAmount.value > 0 && isStripeSelected.value;

  @override
  void onInit() {
    super.onInit();
    _loadCachedPresetAmounts();
  }

  /// Load preset amounts from cache
  void _loadCachedPresetAmounts() async {
    try {
      final cached = await PresetAmountsCacheService.getCachedAmounts();
      presetAmounts.assignAll(cached);
      
      // Set default selected amount to first preset
      if (cached.isNotEmpty) {
        selectedAmount.value = cached[0];
        selectedIndex.value = 0;
      }
    } catch (e) {
      debugPrint('Error loading cached amounts: $e');
    }
  }

  /// Handle preset amount button tap
  void onPresetTap(int index) {
    selectedIndex.value = index;
    customAmountController.clear();
    selectedAmount.value = presetAmounts[index];
  }

  /// Handle custom amount input change
  void onCustomAmountChanged(String value) {
    selectedIndex.value = -1;
    double amount = double.tryParse(value) ?? 0;
    selectedAmount.value = amount;
  }

  /// Toggle Stripe payment method
  void onToggleStripe() {
    isStripeSelected.toggle();
  }

  /// Add custom amount to preset amounts cache
  Future<void> onAddToCache() async {
    final amount = double.tryParse(customAmountController.text) ?? 0;

    if (amount <= 0) {
      EasyLoading.showError('Please enter a valid amount');
      return;
    }

    try {
      // Add to cache
      await PresetAmountsCacheService.addAmount(amount);

      // Update preset amounts from cache
      _loadCachedPresetAmounts();

      // Clear input and select the newly added amount
      customAmountController.clear();
      selectedIndex.value = presetAmounts.length - 1;
      selectedAmount.value = amount;

      EasyLoading.showSuccess(
        'S\$${amount.toStringAsFixed(2)} added to preset amounts',
      );
    } catch (e) {
      debugPrint('Error adding to cache: $e');
      EasyLoading.showError('Failed to save amount');
    }
  }

  /// Initiate payment and open Stripe payment sheet
  Future<void> onAddFunds() async {
    if (!isAddButtonEnabled) {
      EasyLoading.showError('Please select a valid amount');
      return;
    }

    isLoading.value = true;

    try {
      EasyLoading.show(status: 'Processing payment...');
      debugPrint('➡️ Step 1: Initiating add funds payment for amount: \$${selectedAmount.value}');

      // Call Add Money API
      debugPrint('➡️ Step 2: Calling Add Money API');
      final response = await AddFundsPaymentService.addMoneyToWallet(
        amount: selectedAmount.value,
        currency: 'sgd', // Using SGD as primary currency
      );

      debugPrint('✅ Add Money API Response: ${response['body']}');

      if (!response['success']) {
        debugPrint('❌ API Error: ${response['body']}');
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get payment details');
        isLoading.value = false;
        return;
      }

      final clientSecret = response['body']['data']?['clientSecret'];

      if (clientSecret == null || clientSecret.isEmpty) {
        debugPrint('❌ Client secret missing from response');
        EasyLoading.dismiss();
        EasyLoading.showError('Invalid payment response');
        isLoading.value = false;
        return;
      }

      debugPrint('✅ Client Secret obtained: $clientSecret');

      // Initialize Stripe Payment Sheet with client secret
      debugPrint('➡️ Step 3: Initializing Payment Sheet');
      
      EasyLoading.dismiss();
      EasyLoading.show(status: 'Opening payment sheet...');

      try {
        // Use Stripe Payment Sheet Handler to present payment
        // We'll directly use Stripe instance from flutter_stripe
        final paymentResult = await StripePaymentSheetHandler.initiatePayment(
          amount: selectedAmount.value,
          orderId: 0, // No order ID for wallet top-up
        );

        if (paymentResult != null) {
          debugPrint('✅ Payment successful: $paymentResult');
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Payment successful! Funds added to wallet.');
          
          // Add amount to cached preset amounts
          await PresetAmountsCacheService.addAmount(selectedAmount.value);
          _loadCachedPresetAmounts();
          
          // Clear selection after successful payment
          await Future.delayed(Duration(seconds: 2));
          Get.back();
        } else {
          debugPrint('❌ Payment cancelled or failed');
          EasyLoading.dismiss();
        }
      } catch (e) {
        debugPrint('❌ Payment Sheet error: $e');
        EasyLoading.dismiss();
        EasyLoading.showError('Payment failed: $e');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment failed: $e');
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
