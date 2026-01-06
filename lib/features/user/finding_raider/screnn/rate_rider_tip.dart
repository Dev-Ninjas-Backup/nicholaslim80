import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:ZipBee/features/user/finding_raider/controller/rider_controller.dart';
import 'package:ZipBee/features/user/finding_raider/widget/button.dart';
import 'package:ZipBee/features/user/finding_raider/widget/payment_option_widget.dart';
import 'package:ZipBee/features/user/finding_raider/widget/tip_aleart_dialog.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RateRiderTip extends StatelessWidget {
  final RiderController controller = Get.find<RiderController>();
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
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(ImagePath.profileImage),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  controller.riderName.value,
                  style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Center(
                child: Text(
                  'Wow! A 4 star!\nDo you want to tip your rider?',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25),

              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                              Text(
                                'Tipping your rider',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.paymentOptions.length,
                                separatorBuilder: (_, __) => Divider(
                                  color: Colors.grey.shade300,
                                  height: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final option =
                                      controller.paymentOptions[index];
                                  return PaymentOptionWidget(
                                    index: index,
                                    option: option,
                                  );
                                },
                              ),
                              SizedBox(height: 20),

                              raiderTipAmount(),
                              SizedBox(height: 20),

                              Button(
                                buttonText: 'Give a Tip',
                                backgroundColor: AppColors.primaryButtonColor,
                                textColor: AppColors.fontColor,
                                onPressed: () {
                                  Get.dialog(
                                    TipAleartDialog(),
                                    barrierDismissible: true,
                                  );
                                },
                              ),
                              SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      AppRoutes.getexpressDelivery1(),
                                    );
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

  Widget raiderTipAmount() {
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
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                child: Text(
                  'S\$${controller.raiderTipOptions[index].toStringAsFixed(0)}',
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
