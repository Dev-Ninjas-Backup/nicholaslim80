import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/widgets/custom_app_bar.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/rider/app_quiz/widget/large_box.dart';
import 'package:nicholaslim80/features/rider/app_quiz/widget/small_box.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class AppQuizScreen extends StatelessWidget {
  const AppQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(lable: 'App Quiz'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brief explanation about quiz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SmallBox(
                      iconPath: IconPath.file,
                      title: '10 Question',
                      description: '10 Point for Correct\nanswer',
                    ),
                    Spacer(),
                    SmallBox(
                      iconPath: IconPath.timer,
                      title: '30 Min',
                      description: 'Total duration of the\nquiz',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                LargeBox(
                  iconPath: IconPath.star,
                  title: 'Win 10 Star',
                  description: 'Answer all questions correctly',
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'One time Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFB38F00),
                      fontFamily: 'Nunito Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: const Color(0xFFB38F00),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please read the text below carefully so you can understand it',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '- 10 point awarded for a correct answer and no marks for a incorrect answer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '- Tap on options to select the correct answer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '- Tap on the bookmark icon to save interesting questions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '- Click submit if you are sure you want to complete all the quizzes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontColor,
                  ),
                ),
                SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.appCouresScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButtonColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue Quiz',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
