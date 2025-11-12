import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/app_colors.dart';

import 'package:nicholaslim80/features/user/home/my_riders/widgets/my_riders_widget.dart';
import '../controller/my_riders_controller.dart';

class MyRidersScreen extends StatelessWidget {
  const MyRidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyRidersController());

    return Scaffold(
      backgroundColor: AppColors.backgroungColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Riders',
              style: getTextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.info_outline, color: Colors.black87, size: 20),
          ],
        ),
      ),
      body: RidersListWidget(controller: controller),
    );
  }
}
