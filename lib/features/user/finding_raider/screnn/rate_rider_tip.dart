import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:ZipBee/features/user/finding_raider/model/payment_option_model.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/payment_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/rider_tip.dart';

class RateRiderTip extends StatelessWidget {
  final RiderTipController controller = Get.put(RiderTipController());

  RateRiderTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroungColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(IconPath.colorFullArrow, width: 24, height: 24),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: controller.riderImage.value.isNotEmpty
                      ? NetworkImage(controller.riderImage.value)
                      : AssetImage(ImagePath.profileImage) as ImageProvider,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  controller.riderName.value,
                  style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              /// ---------------- STARS ----------------
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < controller.riderRating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 28,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),

              Center(
                child: Text(
                  'Wow! ${controller.riderRating.value.toStringAsFixed(1)} star!\nDo you want to tip your rider?',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),

              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tipping your rider',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.paymentOptions.length,
                                separatorBuilder: (_, __) => Divider(
                                  color: Colors.grey.shade300,
                                  height: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final option =
                                      controller.paymentOptions[index];
                                  final paymentModel = PaymentOptionModel(
                                    title: option["title"] ?? "",
                                    subtitle: option["method"] ?? "",
                                  );
                                  return PaymentOptionWidget(
                                    index: index,
                                    option: paymentModel,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              _buildTipAmountSelection(),

                              const SizedBox(height: 20),

                              Button(
                                buttonText: 'Give a Tip',
                                backgroundColor: AppColors.primaryButtonColor,
                                textColor: AppColors.fontColor,
                                onPressed: () {
                                  controller.submitTip();
                                },
                              ),
                              const SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => BottomNavbarScreen());
                                  },
                                  child: Text(
                                    'Maybe next time',
                                    style: getTextStyle(
                                      color: AppColors.primaryFontColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- TIP AMOUNT SELECTION ----------------
  Widget _buildTipAmountSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(controller.raiderTipOptions.length, (index) {
        return Obx(
          () => GestureDetector(
            onTap: () => controller.selectTip(index),
            child: Card(
              elevation: controller.selectedRaiderTip.value == index ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: controller.selectedRaiderTip.value == index
                  ? Colors.amber
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                child: Text(
                  '\$${controller.raiderTipOptions[index].toStringAsFixed(0)}',
                  style: TextStyle(
                    color: controller.selectedRaiderTip.value == index
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
