import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nicholaslim80/core/common/styles/global_text_style.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../controller/take_now_controller.dart';

class SlideToTakeButtonWidget extends StatelessWidget {
  final TakeNowController ctrl;
  final double width;

  SlideToTakeButtonWidget({super.key, required this.ctrl, required this.width});

  @override
  Widget build(BuildContext context) {
    final double buttonSize = 68;
    final double leftGap = 12;
    final double maxDrag = width - buttonSize - leftGap;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 68,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.primaryButtonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 55),
                  Text(
                    "SLIDE TO TAKE",
                    style: getTextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              Text(
                "Now",
                style: getTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Only the draggable button wrapped in Obx
        Obx(() {
          return Positioned(
            left: ctrl.dragX.value + leftGap,
            top: 12,
            bottom: 12,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                ctrl.dragX.value += details.delta.dx;
                if (ctrl.dragX.value < 0) ctrl.dragX.value = 0;
                if (ctrl.dragX.value > maxDrag) ctrl.dragX.value = maxDrag;
              },
              onHorizontalDragEnd: (_) {
                if (ctrl.dragX.value >= maxDrag * 0.9) {
                  ctrl.onSlideComplete();
                } else {
                  ctrl.resetSlide();
                }
              },
              child: Container(
                height: 38,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 6, top: 12, bottom: 12),
                  child: Image.asset(
                    IconPath.playicon,
                    height: 16,
                    width: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
