import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_add_funds_controller.dart';

class UserAddFunds extends StatelessWidget {
  const UserAddFunds({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAddFundsController controller =
        Get.put(UserAddFundsController());

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            /// 🔹 Amount Title
            Text(
              'How much do you want to add?',
              style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),

            /// 🔹 Preset Amount Buttons
            Obx(
              () => Wrap(
                spacing: 14,
                children: List.generate(
                  controller.presetAmounts.length,
                  (index) {
                    final selected =
                        controller.selectedIndex.value == index;

                    return GestureDetector(
                      onTap: () =>
                          controller.onPresetTap(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 21,
                            vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.amber
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.grey,
                          ),
                        ),
                        child: Text(
                          "\$${controller.presetAmounts[index].toInt()}",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w600,
                            color: selected
                                ? Colors.black
                                : Colors.grey[800],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// 🔹 Custom Amount
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        controller.customAmountController,
                    keyboardType:
                        TextInputType.number,
                    onChanged:
                        controller.onCustomAmountChanged,
                    decoration: InputDecoration(
                      hintText:
                          "Enter a custom amount",
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor:
                          Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed:
                      controller.onAddToCache,
                  icon: const Icon(Icons.add,
                      color: Colors.black),
                  label:
                      const Text('Add'),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🔹 Payment Method Title
            Text(
              'Payment Method',
              style: getTextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Divider(),

            /// 🔥 Saved Card / Stripe Option
            Obx(
              () => GestureDetector(
                onTap:
                    controller.onToggleStripe,
                child: Row(
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color:
                          Colors.blueAccent,
                    ),
                    const SizedBox(
                        width: 12),

                    /// 🔥 If card exists show brand + last4
                    Expanded(
                      child: controller
                              .hasSavedCard
                              .value
                          ? Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  controller
                                      .savedCardBrand
                                      .value,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                Text(
                                  "**** ${controller.savedCardLast4.value}",
                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .grey,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              "Pay via Stripe",
                            ),
                    ),

                    /// 🔘 Radio indicator
                    Container(
                      width: 22,
                      height: 22,
                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        border: Border.all(
                          color: controller
                                  .isStripeSelected
                                  .value
                              ? Colors
                                  .amber
                              : Colors
                                  .grey,
                          width: 2,
                        ),
                        color: controller
                                .isStripeSelected
                                .value
                            ? Colors
                                .amber
                            : Colors
                                .transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),

            /// 🔹 Add Payment Method Toggle
            InkWell(
              onTap: controller
                  .togglePaymentMethodForm,
              child: Obx(
                () => Row(
                  children: [
                    const Icon(
                        Icons.add),
                    const SizedBox(
                        width: 8),
                    const Text(
                        "Add payment method"),
                    const Spacer(),
                    Icon(
                      controller
                              .showPaymentMethodForm
                              .value
                          ? Icons
                              .arrow_drop_up
                          : Icons
                              .arrow_forward_ios,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Payment Sheet Button
            Obx(
              () => controller
                      .showPaymentMethodForm
                      .value
                  ? Column(
                      children: [
                        const SizedBox(
                            height: 16),
                        SizedBox(
                          width: double
                              .infinity,
                          height: 48,
                          child:
                              ElevatedButton(
                            onPressed: controller
                                    .isAddingPaymentMethod
                                    .value
                                ? null
                                : controller
                                    .addPaymentMethod,
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors
                                      .amber,
                            ),
                            child: controller
                                    .isAddingPaymentMethod
                                    .value
                                ? const CircularProgressIndicator(
                                    color:
                                        Colors
                                            .black,
                                  )
                                : const Text(
                                    "Add Card via Stripe",
                                    style: TextStyle(
                                        color:
                                            Colors.black),
                                  ),
                          ),
                        ),
                        const SizedBox(
                            height: 16),
                      ],
                    )
                  : const SizedBox
                      .shrink(),
            ),
          ],
        ),
      ),

      /// 🔹 Bottom Add Fund Button
      bottomNavigationBar:
          Padding(
        padding:
            const EdgeInsets.all(18),
        child: Obx(
          () => SizedBox(
            height: 55,
            width: double.infinity,
            child:
                ElevatedButton(
              onPressed:
                  controller
                          .isLoading
                          .value
                      ? null
                      : controller
                          .onAddFunds,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    Colors.amber,
              ),
              child: controller
                      .isLoading
                      .value
                  ? const CircularProgressIndicator(
                      color:
                          Colors.black,
                    )
                  : const Text(
                      "Add Fund",
                      style: TextStyle(
                          color:
                              Colors.black),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
