import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_add_funds_controller.dart';
import '../controller/add_funds_payment_controller.dart';

class UserAddFunds extends StatelessWidget {
  const UserAddFunds({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAddFundsController controller = Get.put(UserAddFundsController());
    final AddFundsPaymentController paymentController = Get.put(
      AddFundsPaymentController(),
    );

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "Add Funds",
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'How much do you want to add?',
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),

              // 🔹 Preset Amount Buttons
              Obx(
                () => Center(
                  child: Wrap(
                    spacing: 14,
                    runSpacing: 10,
                    children: List.generate(controller.presetAmounts.length, (
                      index,
                    ) {
                      bool selected = controller.selectedIndex.value == index;

                      return GestureDetector(
                        onTap: () => controller.onPresetTap(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 21,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? Colors.amber : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : Colors.grey,
                            ),
                          ),
                          child: Text(
                            "\$${controller.presetAmounts[index].toInt()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.black : Colors.grey[800],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🔹 Custom Amount Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.customAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: controller.onCustomAmountChanged,
                      decoration: InputDecoration(
                        hintText: "Enter a custom amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: controller.onAddToCache,
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🔹 Payment Method
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 0.8),

              // Stripe Option
              Obx(
                () => GestureDetector(
                  onTap: controller.onToggleStripe,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Stripe",
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Card Number",
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Mastercard ****456",
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.isStripeSelected.value
                                  ? Colors.amber
                                  : Colors.grey,
                              width: 2,
                            ),
                            color: controller.isStripeSelected.value
                                ? Colors.amber
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(thickness: 0.8),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // ================= BOTTOM BUTTON =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18),
        child: Obx(
          () => SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  (paymentController.isLoading.value ||
                      !controller.isAddButtonEnabled)
                  ? null
                  : () {
                      paymentController.processWalletTopUp(
                        amount: controller.selectedAmount.value,
                        onPaymentSuccess: () {
                          Get.back();
                        },
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.amber.withOpacity(0.6),
              ),
              child: paymentController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(
                      "Add Fund",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
