import 'package:ZipBee/core/common/styles/global_text_style.dart';
import 'package:ZipBee/core/utils/constants/app_colors.dart';
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';


class SmallHorizontalSlider extends StatelessWidget {
  const SmallHorizontalSlider({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: width * 0.9,

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 28),
              decoration: BoxDecoration(
                color: Color(0xFFFFE16B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buy GPS',
                          style: getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        //SizedBox(height: 4),
                        Text(
                          'Invite friends and get 10 credit for every successful signup',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleFontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    IconPath.mappin,
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
