import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';
import 'package:nicholaslim80/core/utils/constants/image_path.dart';
import 'package:nicholaslim80/features/user/auth/login/controller/login_signup_controller.dart';

class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginSignupController());

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImagePath.backgroundImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() {
                    final isLogin = controller.isLoginSelected.value;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isLogin ? 'Welcome Back!' : 'Welcome!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isLogin
                              ? 'Log in to continue delivering with ease.'
                              : 'Sign up to continue delivering with ease.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleFontColor,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Login / Signup Toggle
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.fromLTRB(
                            isLogin ? 6 : 12,
                            6,
                            isLogin ? 12 : 6,
                            6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.subtitleFontColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => controller.toggleSelection(true),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLogin
                                        ? AppColors.primaryButtonColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => controller.toggleSelection(false),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isLogin
                                        ? AppColors.primaryButtonColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),

                        // Signup fields
                        if (!isLogin) ...[
                          buildTextField(
                            controller.nameController,
                            'Your Name',
                          ),
                          SizedBox(height: 20),
                          buildTextField(
                            controller.emailController,
                            'Your e-mail address',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                        ],

                        if (isLogin)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login with your phone number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        if (isLogin) SizedBox(height: 10),

                        Container(
                          height: 52,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.subtitleFontColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.selectedCountry.value,
                                  items: controller.countries
                                      .map(
                                        (country) => DropdownMenuItem(
                                          value: country,
                                          child: Text(
                                            country,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.selectCountry(value);
                                    }
                                  },
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter phone number',
                                      border: InputBorder.none,
                                      isDense: true,
                                      suffixIcon:
                                          controller
                                              .phoneNumber
                                              .value
                                              .isNotEmpty
                                          ? GestureDetector(
                                              onTap: controller.clearPhone,
                                              child: Icon(
                                                Icons.clear_outlined,
                                                size: 20,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        GestureDetector(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color.fromARGB(255, 152, 122, 2),
                                decoration: TextDecoration.underline,
                                decorationColor: Color.fromARGB(
                                  255,
                                  152,
                                  122,
                                  2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // Button-------->
                        ElevatedButton(
                          onPressed: () {
                            if (controller.isLoginSelected.value) {
                              controller.onLoginPressed();
                            } else {
                              controller.onSignUpContinuePressed();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryButtonColor,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isLogin ? 'Login' : 'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.subtitleFontColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
