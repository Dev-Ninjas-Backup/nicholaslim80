import 'package:flutter/material.dart';

class AppColors {
  //Gradient background colors
  BoxDecoration buildGradientBackground(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final stopPoint = (screenHeight - 506) / screenHeight;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFFFFFFFF), Color(0xFF0088A3)],
        stops: [stopPoint.clamp(0.0, 1.0), 1.0],
      ),
    );
  }

  //Font colors
  static const Color primaryFontColor = Color(0xFF141414);
  //TextField colors
  static const Color textFieldFillColor = Color(0xFFF5F5F5);
  //Font color
  static const Color fontColor = Color(0xFF636363);
  //Border color
  static const Color borderColor = Color(0xFFEBEBEB);

}