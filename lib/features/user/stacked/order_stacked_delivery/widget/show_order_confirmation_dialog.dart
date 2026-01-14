import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/controller/controller.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/custom_toggle_switch_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/order_confirmation_dialog.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/order_success_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/payment_method_widget.dart';
import 'package:ZipBee/features/user/stacked/order_stacked_delivery/widget/promo_dialog_widget.dart';
import 'package:ZipBee/features/user/stacked/stacked_screen/stacked_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

/// Show order confirmation dialog
void showStackedOrderConfirmationDialog(StackedOrderController controller) {
  /// Ensure payment controller exists
  StackedPaymentController paymentCtrl;
  try {
    paymentCtrl = Get.find<StackedPaymentController>();
  } catch (_) {
    paymentCtrl = Get.put(StackedPaymentController());
  }

  final codCollectFrom = 'RECEIVER'.obs;

  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      content: SingleChildScrollView(
        child: Container(
          width: Get.width * 0.95,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Order",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 22),

              /// Promo Code
              Row(
                children: [
                  Image.asset(IconPath.promo, height: 24, width: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Promo Code',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "Promo Code",
                                style: getTextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: Get.back,
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          content: Builder(
                            builder: (context) {
                              final width =
                                  MediaQuery.of(context).size.width * 0.8;
                              return SizedBox(
                                width: width,
                                child: StackedPromoDialogContent(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 130,
                      height: 27,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Enter code",
                        style: getTextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Redeem Coins
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Redeem 10 Coins',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                    () => StackedCustomToggleSwitch(
                      value: controller.redeemCoins.value,
                      onChanged: controller.toggleRedeemCoins,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Favourite Riders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favourite Riders',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                    () => StackedCustomToggleSwitch(
                      value: controller.favoriteRiders.value,
                      onChanged: controller.toggleFavoriteRiders,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Subtotal
              Obx(
                () => buildDetailRow(
                  "Subtotal:",
                  "\$${controller.totalFee.value > 0 ? controller.totalFee.value.toStringAsFixed(2) : controller.totalAmount.value.toStringAsFixed(2)}",
                ),
              ),

              const SizedBox(height: 10),
              buildDetailRow("Coin/s redeemed:", "\$0.00"),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              buildDetailRow("Saved:", "\$0.00"),

              const SizedBox(height: 10),

              /// Total Amount
              Obx(
                () => buildDetailRow(
                  "Total Amount:",
                  "\$${controller.totalFee.value > 0 ? controller.totalFee.value.toStringAsFixed(2) : controller.totalAmount.value.toStringAsFixed(2)}",
                  isTotal: true,
                ),
              ),

              const SizedBox(height: 30),

              /// Payment Method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Method:',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  StackedPaymentMethodSelector(
                    options: [
                      StackedPaymentOption(
                        title: "Stripe",
                        subtitle: "Instant payment",
                        imageAsset: "assets/icons/stripe_icon.png",
                      ),
                      StackedPaymentOption(
                        title: "Wallet",
                        subtitle: "\$10.50",
                        imageAsset: IconPath.wallet,
                      ),
                      StackedPaymentOption(
                        title: "Cash",
                        subtitle: "To be paid by sender or recipient",
                        imageAsset: IconPath.cash,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Cash collect from
              Obx(() {
                if (paymentCtrl.selectedTitle.value.toLowerCase().contains(
                  'cash',
                )) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash Collect from:',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: codCollectFrom.value,
                        items: const [
                          DropdownMenuItem(
                            value: 'SENDER',
                            child: Text('Sender'),
                          ),
                          DropdownMenuItem(
                            value: 'RECEIVER',
                            child: Text('Receiver'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) codCollectFrom.value = v;
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 32),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () {
                      Get.back();
                      controller.cancelAndReset();
                      Get.off(() => StackedScreen());
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Cancel order',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(IconPath.cancel, height: 14, width: 14),
                      ],
                    ),
                  ),

                  /// Place Order
                  FilledButton(
                    onPressed: () async {
                      final selected = paymentCtrl.selectedTitle.value
                          .toLowerCase();

                      String paymentMethodApi;
                      String? paymentMethodId;
                      String? codCollect;

                      if (selected.contains('cash')) {
                        paymentMethodApi = 'COD';
                        codCollect = codCollectFrom.value;
                      } else if (selected.contains('wallet')) {
                        paymentMethodApi = 'WALLET';
                      } else {
                        paymentMethodApi = 'ONLINE_PAY';
                        paymentMethodId = null;
                      }

                      final ok = await controller.confirmPlaceOrder(
                        paymentMethod: paymentMethodApi,
                        paymentMethodId: paymentMethodId,
                        codCollectFrom: codCollect,
                      );

                      if (ok) {
                        debugPrint(
                          'Final placed total: ${controller.totalAmount.value}',
                        );
                        Get.back();

                        EasyLoading.showSuccess(
                          'Order placed: \$${controller.totalAmount.value.toStringAsFixed(2)}',
                        );

                        StackedOrderConfirmationDialog.show();
                        await Future.delayed(const Duration(seconds: 3));
                        Get.back();
                        StackedOrderSuccessDialog.show();
                      } else {
                        EasyLoading.showError('Failed to place order');
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Place Order',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Helper
Widget buildDetailRow(String title, String value, {bool isTotal = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: getTextStyle(
          fontSize: isTotal ? 16 : 12,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      Text(
        value,
        style: getTextStyle(
          fontSize: isTotal ? 16 : 12,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    ],
  );
}
