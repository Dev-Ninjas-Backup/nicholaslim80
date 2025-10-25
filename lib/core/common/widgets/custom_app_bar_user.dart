import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';

class CustomAppBarUser extends StatelessWidget {
  final String title;
  final Widget? action;

  const CustomAppBarUser({required this.title, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios, size: 18),
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          action ?? const SizedBox(width: 18),
        ],
      ),
    );
  }
}
