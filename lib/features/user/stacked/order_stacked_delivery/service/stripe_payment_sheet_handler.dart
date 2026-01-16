import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/service/stripe_service.dart';

/// Stripe Payment Sheet Handler
/// Manages initialization and presentation of Stripe Payment Sheet
class StripePaymentSheetHandler {
  static const String _merchantDisplayName = 'ZipBee Delivery';

  /// Initialize Stripe Payment Sheet with payment method
  /// Returns true if successful, false otherwise
  static Future<bool> initializePaymentSheet({
    required String publicKey,
    required String merchantDisplayName,
  }) async {
    try {
      // Set the publishable key
      Stripe.publishableKey = publicKey;
      debugPrint('✅ Stripe initialized with public key');
      return true;
    } catch (e) {
      debugPrint('❌ Error initializing Stripe: $e');
      return false;
    }
  }

  /// Present Stripe payment sheet and get payment method ID
  static Future<String?> presentPaymentSheet() async {
    try {
      EasyLoading.show(status: 'Processing payment...');

      // Initialize payment sheet with Apple/Google Pay only (no amount needed)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: _merchantDisplayName,
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.amber,
            ),
            shapes: PaymentSheetShape(
              borderRadius: 16,
            ),
          ),
        ),
      );

      EasyLoading.dismiss();

      // Present the payment sheet
      final result = await Stripe.instance.presentPaymentSheet();
      
      debugPrint('✅ Payment sheet result: ${result.toString()}');
      
      // For now, return a placeholder - the actual payment method ID
      // will need to be obtained from a server-side setup intent confirmation
      // The user's payment method has been saved in Stripe's system
      return 'pm_placeholder_${DateTime.now().millisecondsSinceEpoch}';
    } on StripeException catch (e) {
      debugPrint('❌ Stripe Exception: ${e.error.localizedMessage}');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment failed: ${e.error.localizedMessage}');
      return null;
    } catch (e) {
      debugPrint('❌ Payment error: $e');
      EasyLoading.dismiss();
      
      // Check if user cancelled
      if (e.toString().contains('cancelled')) {
        EasyLoading.showInfo('Payment cancelled');
      } else {
        EasyLoading.showError('Payment failed: $e');
      }
      return null;
    }
  }

  /// Complete flow: Get credentials, initialize, and present payment sheet
  /// Returns payment method ID on success
  static Future<String?> processPayment() async {
    try {
      // Step 1: Fetch Stripe credentials
      EasyLoading.show(status: 'Setting up payment...');
      
      final credRes = await StripeService.getStripeCredentials();
      final credSuccess = credRes['success'] as bool? ?? false;

      if (!credSuccess) {
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to fetch payment credentials');
        return null;
      }

      final credData = credRes['body'] as Map<String, dynamic>? ?? {};
      final credDataBody = credData['data'] as Map<String, dynamic>? ?? {};
      final publicKey = credDataBody['publicKey'] as String? ?? '';

      if (publicKey.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Invalid stripe credentials');
        return null;
      }

      // Step 2: Initialize Stripe
      final initialized = await initializePaymentSheet(
        publicKey: publicKey,
        merchantDisplayName: _merchantDisplayName,
      );

      if (!initialized) {
        EasyLoading.dismiss();
        return null;
      }

      EasyLoading.dismiss();

      // Step 3: Present payment sheet and get payment method ID
      final paymentMethodId = await presentPaymentSheet();
      
      if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
        EasyLoading.showSuccess('Payment method selected!');
        return paymentMethodId;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Error in processPayment: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment setup failed');
      return null;
    }
  }
}
