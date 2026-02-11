import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_payment_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/preset_amounts_cache_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_stripe_payment_handler.dart';

class AddFundsPaymentController extends GetxController {
  final RxBool isLoading = false.obs;

  /// মূল পেমেন্ট প্রসেস হ্যান্ডেল করার ফাংশন
  Future<void> processWalletTopUp({
    required double amount,
    required Function onPaymentSuccess,
  }) async {
    if (amount <= 0) {
      EasyLoading.showError('Please enter a valid amount');
      return;
    }

    isLoading.value = true;

    try {
      EasyLoading.show(status: 'Processing payment...');
      debugPrint('➡️ Initiating add funds for amount: \$${amount}');

      // Step 1: Add Money API কল করা (with type: 'ADD_MONEY')
      final response = await AddFundsPaymentService.addMoney(
        amount: amount,
        currency: 'sgd',
      );

      if (!response['success']) {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get payment details');
        return;
      }

      final clientSecret = response['body']['data']?['clientSecret'];

      if (clientSecret == null || clientSecret.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Invalid payment response');
        return;
      }

      debugPrint('✅ Client Secret obtained');
      EasyLoading.dismiss();

      // Step 2: Initialize Stripe for Add Funds
      debugPrint('➡️ Initializing Stripe for Add Funds');
      final initialized = await AddFundsStripePaymentHandler.initializeStripe();

      if (!initialized) {
        EasyLoading.showError('Failed to initialize payment');
        return;
      }

      // Step 3: Present Payment Sheet using the clientSecret from Step 1
      final paymentSuccess =
          await AddFundsStripePaymentHandler.presentPaymentSheet(
            clientSecret: clientSecret,
            amount: amount,
          );

      if (paymentSuccess) {
        debugPrint('✅ Payment successful');

        // সফল হলে ক্যাশে সেভ করা
        await PresetAmountsCacheService.addAmount(amount);

        // Callback কল করা (UI আপডেট বা নেভিগেশনের জন্য)
        onPaymentSuccess();
      } else {
        debugPrint('❌ Payment cancelled or failed');
      }
    } catch (e) {
      debugPrint('❌ Error in processWalletTopUp: $e');
      EasyLoading.showError('Payment failed: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
