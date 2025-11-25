import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/auth/verification/controller/verification_controller.dart';
import 'package:nicholaslim80/features/user/auth/verification/widgets/input_box_widget.dart';
import 'package:nicholaslim80/features/user/auth/verification/widgets/verify_button_widget.dart';

import '../../../../../routes/app_routes.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VerificationController controller = Get.put(VerificationController());
    final media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(ImagePath.backgroundImage, fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: media.size.width * 0.07,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: media.size.height * 0.02),

                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },

                    child: Container(
                      width: media.size.width * 0.1,
                      height: media.size.width * 0.1,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppColors.primaryButtonColor.withOpacity(0.6),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black54),
                    ),
                  ),

                  SizedBox(height: media.size.height * 0.22),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Phone Verification',
                        style: getTextStyle(
                          fontSize: media.size.width * 0.05,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryFontColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: media.size.height * 0.02),
                      Text(
                        'Enter your OTP here ',
                        style: getTextStyle(
                          fontSize: media.size.width * 0.035,
                          color: AppColors.primaryFontColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: media.size.height * 0.01),

                      Text(
                        'Please input your OTP sent to your phone number ',
                        style: getTextStyle(
                          fontSize: media.size.width * 0.029,
                          color: AppColors.primaryFontColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: media.size.height * 0.01),
                      Text(
                        '+65 9** *** **6',
                        style: getTextStyle(
                          fontSize: media.size.width * 0.035,
                          color: AppColors.primaryFontColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: media.size.height * 0.05),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return InputBoxField(
                          context: context,
                          controller: controller,
                          index: index,
                          screenWidth: media.size.width,
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: media.size.height * 0.03),

                  Obx(() {
                    return Center(
                      child: controller.canResend
                          ? GestureDetector(
                              onTap: controller.resendCode,
                              child: Text(
                                'Resend code',
                                style: getTextStyle(
                                  color: AppColors.subtitleFontColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: media.size.width * 0.030,
                                ),
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                style: getTextStyle(
                                  fontSize: media.size.width * 0.030,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Resend code in ',
                                    style: getTextStyle(
                                      color: AppColors.subtitleFontColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${controller.secondsLeft.value}s',
                                    style: getTextStyle(
                                      color: AppColors.primaryButtonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  }),

                  SizedBox(height: media.size.height * 0.08),

                  /// Verify Button
                  VerifyButton(controller: controller, media: media),

                  SizedBox(height: media.size.height * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
