import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class CustomAppBarUser extends StatelessWidget {
  final String title;
  final Widget? action;
  final VoidCallback? onTap;

  const CustomAppBarUser({
    required this.title,
    this.action,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 79),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap ?? Get.back,
            child: Icon(Icons.arrow_back_ios, size: 18),
          ),

          Center(
            child: Text(
              title,
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          action ?? const SizedBox(width: 18),
        ],
      ),
    );
  }
}
