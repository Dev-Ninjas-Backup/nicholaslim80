import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_payment_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/preset_amounts_cache_service.dart';
import 'package:ZipBee/features/user/wallet/add_funds/service/add_funds_stripe_payment_handler.dart';

class AddFundsPaymentController extends GetxController {
  final RxBool isLoading = false.obs;

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
      debugPrint('➡️ Initiating wallet top-up: \$${amount}');

      // ✅ FIXED METHOD NAME
      final response =
          await AddFundsPaymentService.addMoneyToWallet(
        amount: amount,
        currency: 'sgd',
      );

      if (!response['success']) {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to get payment details');
        return;
      }

      // ✅ SAFE NULL CHECK
      final clientSecret =
          response['body']?['data']?['clientSecret'];

      if (clientSecret == null ||
          clientSecret.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError(
            'Invalid payment response');
        return;
      }

      debugPrint('✅ Client Secret received');
      EasyLoading.dismiss();

      // Initialize Stripe
      final initialized =
          await AddFundsStripePaymentHandler
              .initializeStripe();

      if (!initialized) {
        EasyLoading.showError(
            'Failed to initialize payment');
        return;
      }

      // Present Payment Sheet
      final paymentSuccess =
          await AddFundsStripePaymentHandler
              .presentPaymentSheet(
        clientSecret: clientSecret,
        amount: amount,
      );

      if (paymentSuccess) {
        debugPrint('✅ Payment successful');

        await PresetAmountsCacheService
            .addAmount(amount);

        onPaymentSuccess();
      } else {
        debugPrint(
            '❌ Payment cancelled or failed');
      }
    } catch (e) {
      debugPrint(
          '❌ processWalletTopUp error: $e');
      EasyLoading.showError(
          'Payment failed: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
