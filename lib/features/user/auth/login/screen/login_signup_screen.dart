import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                        const SizedBox(height: 20),

                        // Login / Signup Toggle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
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
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.symmetric(
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
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => controller.toggleSelection(false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.symmetric(
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
                                    style: getTextStyle(
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
                        const SizedBox(height: 40),

                        // Animated section for Login / Signup fields
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.2),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: isLogin
                              ? buildLoginFields(controller)
                              : buildSignupFields(controller),
                        ),

                        const SizedBox(height: 30),

                        // Button
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
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isLogin ? 'Login' : 'Continue',
                            style: getTextStyle(
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

  // Build login fields
  Widget buildLoginFields(LoginSignupController controller) {
    return Column(
      key: const ValueKey('loginFields'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login with your phone number',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildPhoneField(controller),
        const SizedBox(height: 20),
        buildPasswordField(
          controller.passwordController,
          controller.isLoginPasswordVisible,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Build signup fields
  Widget buildSignupFields(LoginSignupController controller) {
    return Column(
      key: const ValueKey('signupFields'),
      children: [
        buildTextField(controller.nameController, 'Your Name'),
        const SizedBox(height: 20),
        buildTextField(
          controller.emailController,
          'Your e-mail address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _buildPhoneField(controller),
        const SizedBox(height: 20),
        buildPasswordField(
          controller.passwordController,
          controller.isSignUpPasswordVisible,
          'Enter your password',
        ),
        const SizedBox(height: 20),
        buildPasswordField(
          controller.confirmPasswordController,
          controller.isConfirmPasswordVisible,
          'Confirm your password',
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Password Field with toggle visibility
  Widget buildPasswordField(
    TextEditingController controller,
    RxBool isVisible, [
    String hint = 'Password',
  ]) {
    return Obx(() {
      return Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.subtitleFontColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          obscureText: !isVisible.value,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            isDense: true,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible.value ? Icons.visibility : Icons.visibility_off,
                size: 20,
              ),
              onPressed: () {
                isVisible.value = !isVisible.value;
              },
            ),
          ),
        ),
      );
    });
  }

  // Updated Phone Field with Left TextField & Right CountryCodePicker
  Widget _buildPhoneField(LoginSignupController controller) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.subtitleFontColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  border: InputBorder.none,
                  isDense: true,
                  suffixIcon: controller.phoneNumber.value.isNotEmpty
                      ? GestureDetector(
                          onTap: controller.clearPhone,
                          child: const Icon(Icons.clear_outlined, size: 20),
                        )
                      : null,
                ),
              ),
            ),
          ),
          CountryCodePicker(
            onChanged: (country) {
              controller.selectedCountry.value = country.dialCode ?? '+1';
            },
            initialSelection: controller.selectedCountry.value,
            favorite: ['+1', '+880'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
