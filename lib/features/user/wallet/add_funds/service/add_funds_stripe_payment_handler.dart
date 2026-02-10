import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';

/// Stripe Payment Handler specifically for Add Funds flow
/// Uses clientSecret from AddFundsPaymentService - no additional API calls
class AddFundsStripePaymentHandler {
  static const String _merchantDisplayName = StripeKeys.merchantDisplayName;

  /// Initialize Stripe with public key
  static Future<bool> initializeStripe({String? publicKey}) async {
    debugPrint('➡️ Initializing Stripe for Add Funds');
    try {
      final key = publicKey ?? StripeKeys.stripePublicKey;

      if (key.isEmpty) {
        debugPrint('❌ Stripe public key is empty');
        return false;
      }

      Stripe.publishableKey = key;
      debugPrint('✅ Stripe initialized for Add Funds');
      return true;
    } catch (e) {
      debugPrint('❌ Error initializing Stripe for Add Funds: $e');
      return false;
    }
  }

  /// Present Stripe Payment Sheet using existing clientSecret
  /// clientSecret should come from AddFundsPaymentService.addMoney()
  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required double amount,
  }) async {
    try {
      debugPrint(
        '➡️ Step 1: Presenting Payment Sheet for wallet top-up (\$$amount)',
      );
      debugPrint('➡️ Client Secret: $clientSecret');

      EasyLoading.show(status: 'Opening payment sheet...');

      // Initialize Payment Sheet with clientSecret
      debugPrint('➡️ Step 2: Initializing Payment Sheet');
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: _merchantDisplayName,
            style: ThemeMode.light,
            appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(primary: Colors.amber),
              shapes: PaymentSheetShape(borderRadius: 16),
            ),
          ),
        );
        debugPrint('✅ Payment Sheet initialized successfully');
      } catch (initError) {
        debugPrint('❌ Payment Sheet init error: $initError');
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to initialize payment: $initError');
        return false;
      }

      EasyLoading.dismiss();

      // Present Payment Sheet
      debugPrint('➡️ Step 3: Presenting Payment Sheet to user');
      EasyLoading.show(status: 'Processing payment...');

      try {
        await Stripe.instance.presentPaymentSheet();
        debugPrint('✅ Payment Sheet presented and confirmed');
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Payment Successful!');
        return true;
      } catch (e) {
        debugPrint('❌ Presentation error: $e');
        EasyLoading.dismiss();

        if (e.toString().contains('cancelled')) {
          debugPrint('⚠️ User cancelled payment');
          EasyLoading.showInfo('Payment cancelled');
        } else {
          EasyLoading.showError('Payment sheet error: $e');
        }
        return false;
      }
    } on StripeException catch (e) {
      debugPrint('❌ Stripe Exception: ${e.error.localizedMessage}');
      debugPrint('❌ Stripe Error Code: ${e.error.code}');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment failed: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('❌ Error: $e');
      EasyLoading.dismiss();

      if (e.toString().contains('cancelled')) {
        debugPrint('⚠️ User cancelled payment');
        EasyLoading.showInfo('Payment cancelled');
      } else {
        EasyLoading.showError('Payment failed: $e');
      }
      return false;
    }
  }
}
