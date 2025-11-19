import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/widget/custom_toggoe_switich_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/widget/order_confirmation_dialog.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/widget/order_success_dialog.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/widget/payment_method_widget.dart';
import 'package:nicholaslim80/features/user/%20express_delivery_1/order_express_delivery/widget/promo_dilog_widget.dart';

class OrderControllerScreen extends GetxController {
  double totalAmount = 0.00;

  // ✅ Track toggle state
  RxBool redeemCoins = false.obs;
  RxBool favoriteRiders = false.obs;

  // ---------- FULL-WIDTH CONFIRMATION DIALOG ----------
  void showConfirmationDialog() {
    final String formattedTotal = "S\$${totalAmount.toStringAsFixed(2)}";

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(10), // 🔥 Full width
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: Get.width, // Full width
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- TITLE ----------
                Text(
                  "Your Order",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 22),

                // ---------- PROMO CODE ROW ----------
                Row(
                  children: [
                    Image.asset(IconPath.promo, height: 24, width: 24),
                    SizedBox(width: 8),
                    Text(
                      'Promo Code',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.amber, width: 2),
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
                                Spacer(),
                                InkWell(
                                  onTap: () => Get.back(),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            content: Builder(
                              builder: (context) {
                                final width =
                                    MediaQuery.of(context).size.width *
                                    0.8; // device width er 50%
                                return SizedBox(
                                  width: width,
                                  child: PromoDialogContent(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        height: 27,
                        padding: EdgeInsets.symmetric(horizontal: 8),
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
                SizedBox(height: 8),

                // ---------- REDEEM COINS ----------
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
                      () => CustomToggleSwitch(
                        value: redeemCoins.value,
                        onChanged: (val) => redeemCoins.value = val,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // ---------- FAVOURITE RIDERS ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Favourite Riders ',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => CustomToggleSwitch(
                        value: favoriteRiders.value,
                        onChanged: (val) => favoriteRiders.value = val,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 31),

                // ---------- SUBTOTAL ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: getTextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'S\$45',
                      style: getTextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coin/s redeemed:',
                      style: getTextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '-S\$00',
                      style: getTextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Divider(),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved:',
                      style: getTextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '-S\$00',
                      style: getTextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                _buildDetailRow("Total Amount:", formattedTotal, isTotal: true),
                SizedBox(height: 30),

                // ---------- PAYMENT METHOD ----------
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
                    PaymentMethodSelector(
                      options: [
                        PaymentOption(
                          title: "Stripe",
                          subtitle: "Instant payment",
                          imageAsset: "assets/icons/stripe_icon.png",
                        ),
                        PaymentOption(
                          title: "Wallet ",
                          subtitle: "S\$10.50",
                          imageAsset: IconPath.wallet,
                        ),
                        PaymentOption(
                          title: "Cash",
                          subtitle: "To be paid by sender or receipent",
                          imageAsset: IconPath.cash,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 44),

                // ---------- BUTTONS ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      onPressed: () => Get.back(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: Colors.red, width: 1.5),
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
                          SizedBox(width: 3),
                          Image.asset(IconPath.cencell, height: 14, width: 14),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        Get.back();
                        OrderConfirmationDialog.show();
                        await Future.delayed(Duration(seconds: 3));
                        Get.back();
                        OrderSuccessDialog.show();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Review Order',
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
}

// ---------- HELPER METHOD ----------
Widget _buildDetailRow(String title, String value, {bool isTotal = false}) {
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
