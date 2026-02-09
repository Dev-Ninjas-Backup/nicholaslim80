import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_add_funds_controller.dart';

class UserAddFunds extends StatelessWidget {
  const UserAddFunds({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAddFundsController controller = Get.put(UserAddFundsController());

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            Text(
              'How much do you want to add?',
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),

            // 🔹 Preset Amount Buttons
            Obx(
              () => Center(
                child: Wrap(
                  spacing: 14,
                  children: List.generate(controller.presetAmounts.length, (
                    index,
                  ) {
                    bool selected = controller.selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.onPresetTap(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 21,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? Colors.amber : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected ? Colors.transparent : Colors.grey,
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

            SizedBox(height: 18),

            // 🔹 Custom Amount TextField with Add Button
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
                SizedBox(width: 10),
                // 🔹 Add Button to save custom amount to cache
                ElevatedButton.icon(
                  onPressed: controller.onAddToCache,
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),
            Text(
              'How much do you want to add?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Divider(thickness: 0.8),

            // 🔹 Stripe Payment Method
            Obx(
              () => GestureDetector(
                onTap: controller.onToggleStripe,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        child: Text(
                          "stripe",
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),

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
                            SizedBox(height: 3),
                            Text(
                              "Mastercard ****456",
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
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

            Divider(thickness: 0.8),
            SizedBox(height: 16),

            InkWell(
              onTap: controller.togglePaymentMethodForm,
              child: Obx(
                () => Row(
                  children: [
                    Icon(Icons.add, size: 22),
                    SizedBox(width: 8),
                    Text(
                      "Add payment method",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      controller.showPaymentMethodForm.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_forward_ios,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),

            // Payment Method Form - Toggle visibility
            Obx(
              () => controller.showPaymentMethodForm.value
                  ? Column(
                      children: [
                        SizedBox(height: 16),
                        Divider(thickness: 0.8),
                        SizedBox(height: 16),

                        Text(
                          'Click the button below to add a new payment method.',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: 14),

                        // Open Stripe Payment Sheet Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: controller.isAddingPaymentMethod.value
                                  ? null
                                  : controller.addPaymentMethod,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(
                                Icons.credit_card,
                                color: Colors.black,
                              ),
                              label: Text(
                                controller.isAddingPaymentMethod.value
                                    ? 'Processing...'
                                    : 'Add Card via Stripe',
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Cancel Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed:
                                controller.isAddingPaymentMethod.value
                                    ? null
                                    : controller.togglePaymentMethodForm,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),

      // 🔹 Bottom "Add Fund" Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 55,
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value 
                    ? null 
                    : () => controller.onAddFunds(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.amber.withOpacity(0.6),
                  ),
                  child: controller.isLoading.value
                    ? SizedBox(
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

            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
