import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/features/rider/app_course/controller/app_coures_controller.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class AppCouresScreen extends StatelessWidget {
  final AppCouresController ctrl = Get.put(AppCouresController());

  AppCouresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryFontColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "App Course",
          style: getTextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        final index = ctrl.currentIndex.value;
        final question = ctrl.questions[index];
        final total = ctrl.questions.length;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: total,
                  separatorBuilder: (_, __) => SizedBox(width: 13),
                  itemBuilder: (context, i) {
                    bool isActive = i == index;
                    return Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.onboardingIndicatorActive
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${i + 1}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? AppColors.primaryFontColor
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 63,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.onboardingIndicatorActive
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 20),
              Text(
                question['question'] as String,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryFontColor,
                ),
              ),
              SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: (question['options'] as List).length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final option = (question['options'] as List<String>)[i];
                    final letter = String.fromCharCode(65 + i);
                    final isSelected = ctrl.selectedOption.value == option;

                    return GestureDetector(
                      onTap: () => ctrl.selectOption(option),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (ctrl.isCorrect(option)
                                    // ignore: deprecated_member_use
                                    ? Colors.green.withOpacity(0.2)
                                    : AppColors.onboardingIndicatorActive
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.2))
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected
                                  ? (ctrl.isCorrect(option)
                                        ? Colors.green
                                        : AppColors.onboardingIndicatorActive)
                                  : Colors.grey[300],
                              child: Text(
                                letter,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryFontColor
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryFontColor,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: index > 0 ? ctrl.previousQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(164, 45),
                    ),
                    child: Text(
                      "Previous",
                      style: getTextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: ctrl.selectedOption.value.isNotEmpty
                        ? () {
                            if (ctrl.currentIndex.value ==
                                ctrl.questions.length - 1) {
                              int correctAnswers = 0;
                              for (var i = 0; i < ctrl.questions.length; i++) {
                                if (ctrl.selectedOptions.length > i &&
                                    ctrl.selectedOptions[i] ==
                                        ctrl.questions[i]['answer']) {
                                  correctAnswers++;
                                }
                              }

                              if (correctAnswers == ctrl.questions.length) {
                                Get.toNamed(
                                  AppRoutes.getquizCongratulationScreen(),
                                );
                              } else {
                                Get.toNamed(AppRoutes.gettryAginScreen());
                              }
                            } else {
                              ctrl.nextQuestion();
                            }
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.amber, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(164, 45),
                      backgroundColor: ctrl.selectedOption.value.isNotEmpty
                          ? AppColors.onboardingIndicatorActive
                          : Colors.white,
                    ),
                    child: Text(
                      "Next",
                      style: getTextStyle(
                        color: ctrl.selectedOption.value.isNotEmpty
                            ? Colors.black
                            : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}
