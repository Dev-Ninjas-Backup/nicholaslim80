import 'dart:convert';

import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ZipBee/core/constants/stripe_keys.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Stripe Payment Sheet Handler
/// Manages initialization and presentation of Stripe Payment Sheet
class StripePaymentSheetHandler {
  static const String _merchantDisplayName = StripeKeys.merchantDisplayName;
  static Map<String, dynamic>? paymentIntent;

  /// Initialize Stripe Payment Sheet with payment method
  /// Returns true if successful, false otherwise
  static Future<bool> initializePaymentSheet({
    String? publicKey,
    String merchantDisplayName = _merchantDisplayName,
  }) async {
    debugPrint('➡️ Initializing Stripe with public key');
    try {
      // Use provided key or default to configured key
      final key = publicKey ?? StripeKeys.stripePublicKey;

      if (key.isEmpty) {
        debugPrint('❌ Stripe public key is empty');
        return false;
      }

      // Set the publishable key
      Stripe.publishableKey = key;
      debugPrint(
        '✅ Stripe initialized with public key: ${key.substring(0, 10)}...',
      );
      return true;
    } catch (e) {
      debugPrint('❌ Error initializing Stripe: $e');
      return false;
    }
  }

  /// Create PaymentIntent on backend
  static Future<Map<String, dynamic>?> _createPaymentIntent() async {
    try {
      debugPrint('➡️ Creating SetupIntent on backend');
      final token = await SharedPreferencesHelper.getAccessToken();
      final String backendUrl =
          "https://api.zipbee.sg/api/v1/wallet/create-setup-intent";

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      debugPrint(
        '✅ SetupIntent Response: ${response.statusCode}\n${response.body}',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('❌ Failed to create SetupIntent: ${response.statusCode}');
        return null;
      }

      final paymentIntentData = jsonDecode(response.body);
      debugPrint(
        '✅ SetupIntent created successfully with secret: ${paymentIntentData['clientSecret'] ?? paymentIntentData['client_secret'] ?? "N/A"}',
      );

      return paymentIntentData;
    } catch (e) {
      debugPrint('❌ Error creating PaymentIntent: $e');
      return null;
    }
  }

  /// Present Stripe payment sheet and get payment method ID
  static Future<String?> presentPaymentSheet() async {
    try {
      debugPrint('➡️ Creating PaymentIntent');

      // Step 1: Create PaymentIntent on backend
      paymentIntent = await _createPaymentIntent();

      if (paymentIntent == null) {
        debugPrint('❌ Failed to create PaymentIntent');
        EasyLoading.showError('Failed to create payment intent');
        return null;
      }

      // Extract client secret (handle both camelCase and snake_case)
      final clientSecret =
          paymentIntent!['clientSecret'] ?? paymentIntent!['client_secret'];

      if (clientSecret == null || clientSecret.isEmpty) {
        debugPrint('❌ Client secret is missing from response');
        EasyLoading.showError('Invalid payment response');
        return null;
      }

      debugPrint('✅ Client Secret obtained: $clientSecret');

      // Step 2: Initialize payment sheet with client secret
      debugPrint('➡️ Initializing Payment Sheet');
      EasyLoading.show(status: 'Setting up payment...');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: _merchantDisplayName,
          setupIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Colors.amber),
            shapes: PaymentSheetShape(borderRadius: 16),
          ),
        ),
      );

      debugPrint('✅ Payment Sheet initialized successfully');
      EasyLoading.dismiss();

      // Step 3: Present the payment sheet
      debugPrint('➡️ Presenting Payment Sheet to user');
      EasyLoading.show(status: 'Opening payment sheet...');

      await Stripe.instance.presentPaymentSheet();

      debugPrint('✅ Payment Sheet presented successfully');
      EasyLoading.dismiss();

      // Return success indicator
      return 'payment_method_saved_${DateTime.now().millisecondsSinceEpoch}';
    } on StripeException catch (e) {
      debugPrint('❌ Stripe Exception: ${e.error.localizedMessage}');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment failed: ${e.error.localizedMessage}');
      return null;
    } catch (e) {
      debugPrint('❌ Payment error: $e');
      EasyLoading.dismiss();

      // Check if user cancelled
      if (e.toString().contains('cancelled') ||
          e.toString().contains('USER_CANCELLED')) {
        debugPrint('⚠️ User cancelled payment');
        EasyLoading.showInfo('Payment cancelled');
      } else {
        EasyLoading.showError('Payment failed: $e');
      }
      return null;
    }
  }

  /// Complete flow: Create PaymentIntent, initialize, and present payment sheet
  /// Returns payment method ID on success
  static Future<String?> processPayment() async {
    try {
      if (Get.isBottomSheetOpen == true) {
        debugPrint('➡️ Closing existing bottom sheet');
        Get.back();
      }

      // Validate keys are configured
      if (!StripeKeys.isConfigured()) {
        debugPrint('❌ Stripe keys not configured properly');
        EasyLoading.showError('Payment system not properly configured');
        return null;
      }

      debugPrint('➡️ Starting Stripe payment process');

      // Step 1: Initialize Stripe with configured public key
      EasyLoading.show(status: 'Setting up payment...');

      final initialized = await initializePaymentSheet(
        publicKey: StripeKeys.stripePublicKey,
        merchantDisplayName: _merchantDisplayName,
      );

      if (!initialized) {
        debugPrint('❌ Failed to initialize Stripe');
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to initialize payment system');
        return null;
      }

      EasyLoading.dismiss();

      // Step 2: Present payment sheet
      debugPrint('➡️ Presenting payment sheet');
      final paymentMethodId = await presentPaymentSheet();

      if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
        debugPrint('✅ Payment successful: $paymentMethodId');
        EasyLoading.showSuccess('Payment method selected!');
        return paymentMethodId;
      }

      debugPrint('⚠️ Payment returned null');
      return null;
    } catch (e) {
      debugPrint('❌ Error in processPayment: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Payment setup failed: $e');
      return null;
    }
  }
}